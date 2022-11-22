import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, atan2, pi, sin;

Container blueCircle() {
  return Container(
    width: 25,
    height: 25,
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 3, 137, 247),
      shape: BoxShape.circle,
    ),
  );
}

Container redCircle() {
  return Container(
    width: 25,
    height: 25,
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 247, 113, 3),
      shape: BoxShape.circle,
    ),
  );
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

double deg2rad(deg) {
  return deg * (pi / 180);
}

double calculateDistance(lat1, lng1, lat2, lng2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lng2 - lng1);
  var a = sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  var d = R * c; // Distance in km

  return d;
}

Future<void> sendCancel(FirebaseDatabase fb, String orderid) async {
  final clientprog = await fb
      .ref()
      .child("clientProgress")
      .orderByChild("orderid")
      .equalTo(orderid)
      .get();
  for (var value in clientprog.children) {
    fb.ref().child("clientProgress/${value.key}").remove();
  }
  fb.ref().child("chats/$orderid").remove();
  final deliveyprog = await fb
      .ref()
      .child("deliveryProgress")
      .orderByChild("orderid")
      .equalTo(orderid)
      .get();
  for (var value in deliveyprog.children) {
    fb.ref().child("deliveryProgress/${value.key}").remove();
  }
  fb.ref().child("requests").child(orderid).remove();
}

cancelProccess(BuildContext context, FirebaseDatabase fb, String orderid,
    Future<void> Function() functionpro) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Advertencia"),
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
              const Text("Cancelar orden?"),
            ])),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Si"),
            onPressed: () {
              Navigator.of(context).pop();
              functionpro();
              sendCancel(fb, orderid);
            },
          )
        ],
      );
    },
  );
}

showOkDialog(BuildContext context, String titulo, String informacion) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
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
              Text(informacion),
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

String getActualDate() {
  DateTime now = DateTime.now();

  String convertedDateTime =
      "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  return convertedDateTime;
}

String verificar(String? nro) {
  if (nro!.length == 10 || nro.length == 13) {
    var cp = int.parse(nro.substring(0, 2));
    if (cp >= 1 && cp <= 22) {
      var tercerDig = int.parse(nro[2]);
      if (tercerDig >= 0 && tercerDig < 6) {
        if (nro.length == 10) {
          //valida cedula
          return validarCedulaRuc(nro, 0);
        } else if (nro.length == 13) {
          //valida ruc
          return validarCedulaRuc(nro, 0);
        }
      } else if (tercerDig == 6) {
        //valida sociedad publica
        return validarCedulaRuc(nro, 1);
      } else if (tercerDig == 9) {
        // valida sociedad privada
        return validarCedulaRuc(nro, 2);
      } else {
        return 'Tercer digito invalido';
      }
    } else {
      return 'Codigo de provincia incompleto';
    }
    return '';
  } else {
    return 'Digitos Incompletos';
  }
}

String validarCedulaRuc(String? nro, int tipo) {
  num total = 0;
  var d_ver;
  var multip;
  var base;
  if (tipo == 0) {
    base = 10;
    d_ver = int.parse(nro![9]);
    multip = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  } else if (tipo == 1) {
    base = 11;
    d_ver = int.parse(nro![8]);
    multip = [3, 2, 7, 6, 5, 4, 3, 2];
  } else if (tipo == 2) {
    base = 11;
    d_ver = int.parse(nro![9]);
    multip = [4, 3, 2, 7, 6, 5, 4, 3, 2];
  }
  for (var i = 0; i < multip.length; i++) {
    // TO DO
    var p = int.parse(nro![i]) * multip[i];
    if (tipo == 0) {
      if (p < 10) {
        total += p;
      } else {
        total += int.parse(p.toString()[0]) + int.parse(p.toString()[1]);
      }
    } else {
      total += p;
    }
  }
  var mod = total % base;
  num val;
  if (mod != 0) {
    val = base - mod;
  } else {
    val = 0;
  }

  if (val == d_ver) {
    return '1';
  }
  return '0';
}
