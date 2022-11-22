import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:goubi_delivery/reusable/functions.dart';
import 'package:goubi_delivery/reusable/requests.dart';
import 'package:goubi_delivery/screens/cliente/map.dart';
import 'package:goubi_delivery/screens/home.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:goubi/screens/cliente/servicios/mapa.dart';

class WaterOrderScreen extends StatefulWidget {
  final OrderRequest id;
  const WaterOrderScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<WaterOrderScreen> createState() => _LoginScreenState();
}

late BuildContext dialogContext;
late LatLngRequest lngltn;
late CollectionReference orders;
late WaterRequest waterrequest;
late String userui;

class _LoginScreenState extends State<WaterOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  int gas1Value = 0;
  int gas2Value = 0;
  bool flagAddress = false;
  // late LatLng latlgn;
  final fb = FirebaseDatabase.instance;
  final TextEditingController addresController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  TextEditingController cilindroController = TextEditingController();
  TextEditingController cilindro2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final orderui = widget.id.orderid;
    final ref = fb.ref().child('requests/$orderui');
    userui = FirebaseAuth.instance.currentUser!.uid;
    orders = FirebaseFirestore.instance.collection('orders');
    final BottomNavigationBar navigationBar =
        (globalKey.currentWidget as BottomNavigationBar);
    final addressField = TextFormField(
      autofocus: false,
      controller: addresController,
      readOnly: true,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        addresController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          suffixIcon: Padding(
            padding:
                const EdgeInsets.only(top: 1), // add padding to adjust icon
            child: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(latlnt: lngltn)),
                );
              },
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );

    final referenceField = TextFormField(
      autofocus: false,
      controller: referenceController,
      readOnly: true,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        referenceController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );

    final sendButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: const Color(0XF0F0F0F0),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          //showAlertDialog(context);
          navigationBar.onTap!(2);
        },
        child: const Text(
          "Chat con el cliente",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final card1 = Card(
      color: const Color(0XF0F0F0F0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              child: Image.asset("assets/icon1.png"),
            ),
            title: const Text(
              'Revisa tu solicitud',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Escribe en el chat para acordar un precio'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );

    final gas1Field = Expanded(
        child: SizedBox(
            width: 200.0,
            child: TextFormField(
              autofocus: false,
              readOnly: true,
              controller: cilindroController,
              decoration: InputDecoration(
                  //prefixIcon: const Icon(Icons.mail),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            )));
    final gas2Field = Expanded(
        child: SizedBox(
            width: 200.0,
            child: TextFormField(
              autofocus: false,
              readOnly: true,
              controller: cilindro2Controller,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  //prefixIcon: const Icon(Icons.mail),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            )));

    final gas1Form = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        blueCircle(),
        const SizedBox(width: 20),
        gas1Field,
      ],
    );
    final cancelButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: const Color(0XAEAE0121),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          //showAlertDialog(context);
          cancelProccess(context, fb, widget.id.orderid, sendCancelDatabase);
        },
        child: const Text(
          "Cancelar Pedido",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final mainContainer = Center(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 30, 50),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      card1,
                      const SizedBox(height: 40),
                      gas1Form,
                      const SizedBox(height: 20),
                      addressField,
                      const SizedBox(height: 20),
                      referenceField,
                      const SizedBox(height: 30),
                      sendButton,
                      const SizedBox(height: 10),
                      cancelButton
                    ]),
              )),
        ),
      ),
    );

    return FutureBuilder<DataSnapshot>(
        future: ref.get(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            waterrequest = WaterRequest.fromJson(snapshot.data?.value);
            lngltn = LatLngRequest(waterrequest.lat, waterrequest.lng);
            addresController.text = waterrequest.address;
            referenceController.text = waterrequest.reference;
            cilindroController.text =
                "${waterrequest.waterBottle.toString()} Botellones";

            return mainContainer;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  showLoading() {
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
  }

  Future<void> sendCancelDatabase() async {
    showLoading();
    var document = {
      'reference': waterrequest.reference,
      'uid': waterrequest.uid,
      'address': waterrequest.address,
      'waterBottle': waterrequest.waterBottle,
      'type': waterrequest.type,
      'lat': waterrequest.lat,
      'dui': userui,
      'lng': waterrequest.lng,
      'date': getActualDate(),
      'deliveryCancel': true,
      'complete': false,
      'clientCancel': false,
    };
    orders
        .add(document)
        .then((value) async => {
              Navigator.pop(dialogContext),
              await fb.ref().child("requests").child(widget.id.orderid).remove()
            })
        .catchError((error) => print("Failed to add order: $error"));
  }
}
