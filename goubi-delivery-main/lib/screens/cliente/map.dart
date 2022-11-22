import 'dart:async';
import 'package:goubi_delivery/reusable/functions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:goubi_delivery/reusable/requests.dart';

class MapScreen extends StatefulWidget {
  final LatLngRequest latlnt;
  const MapScreen({Key? key, required this.latlnt}) : super(key: key);

  @override
  _SimpleMapScreenState createState() => _SimpleMapScreenState();
}

late BuildContext dialogContext;

class _SimpleMapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late Position currentLocation;
  bool flag_position = true;
  final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialPosition = CameraPosition(
        target: LatLng(widget.latlnt.lat, widget.latlnt.lng), zoom: 16.0);
    final Marker marker = Marker(
        markerId: const MarkerId("position"),
        position: LatLng(widget.latlnt.lat, widget.latlnt.lng));
    markers.add(marker);
    final mapa = GoogleMap(
      initialCameraPosition: initialPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );

    return MaterialApp(
        title: 'Home Page',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Ubicacion de Recogida",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: mapa,
            floatingActionButton: Row(children: [
              FloatingActionButton(
                  backgroundColor: Colors.black,
                  heroTag: null,
                  onPressed: () {
                    goToLake();
                  },
                  child: const Icon(Icons.location_on_sharp)),
            ]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat));
  }

  Future<void> goToLake() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await determinePosition();
    final latLong = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 16.0,
        tilt: 0);

    controller.animateCamera(CameraUpdate.newCameraPosition(latLong));
    flag_position = true;
  }

  Future<void> sendInfoBack() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await determinePosition();
    final latLong = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14.0,
        bearing: 192.0,
        tilt: 0);

    controller.animateCamera(CameraUpdate.newCameraPosition(latLong));
  }

  Future<void> _getLocation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    var details = {};
    LatLng position = await getCenter();

    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      details["address"] = place;
      details["coord"] = position;
      Navigator.pop(dialogContext);
      Navigator.pop(context, details);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<LatLng> getCenter() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: SizedBox(
              height: 120,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 70,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Por favor seleccione su ubicacion"),
              ])),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
