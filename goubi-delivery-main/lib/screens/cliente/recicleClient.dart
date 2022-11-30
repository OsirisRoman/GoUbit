import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goubi_delivery/reusable/functions.dart';
import 'package:goubi_delivery/reusable/requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goubi_delivery/screens/cliente/pedido/mainOrder.dart';

class RecicleClientScreen extends StatefulWidget {
  const RecicleClientScreen({Key? key}) : super(key: key);

  @override
  State<RecicleClientScreen> createState() => _HomeWidgetState();
}

late BuildContext dialogContext;
late Position position;
late double distance;

class _HomeWidgetState extends State<RecicleClientScreen> {
  final fb = FirebaseDatabase.instance;
  var isSwitched = true;
  Future<void> setupToken() async {
    await FirebaseMessaging.instance.subscribeToTopic('recicleRequest');
  }

  Future<void> setupPosition() async {
    position = await determinePosition();
  }

  Future<void> setupDistance() async {
    FirebaseFirestore.instance
        .collection('settings')
        .doc('data')
        .get()
        .then((value) => distance = value["radio_1"].toDouble());
  }

  @override
  void initState() {
    super.initState();
    setupToken();
    setupPosition();
    setupDistance();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('requests');
    final userui = FirebaseAuth.instance.currentUser?.uid;
    DocumentReference users_ref =
        FirebaseFirestore.instance.collection('users').doc(userui);
    Future<void> acceptOrder(RecicleRequest recicleRequest, String? key) async {
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
      DatabaseReference refDelivery =
          FirebaseDatabase.instance.ref("deliveryProgress/$userui");
      final clientui = recicleRequest.uid;
      DatabaseReference refClient =
          FirebaseDatabase.instance.ref("clientProgress/$clientui");
      fb.ref().child("clientProgress/$clientui").remove();
      refDelivery.update({"orderid": key, "type": "recicle"}).then((_) {
        refClient.update({
          "status": "accepted",
          "orderid": key,
          "type": "recicle"
        }).then((_) {
          Navigator.pop(dialogContext);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainOrderScreen()),
              (route) => false);
        });
      });
    }

    Material _solicitudButton(RecicleRequest recicleRequest, String? key) {
      return Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(5),
        color: Colors.black,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            await acceptOrder(recicleRequest, key);
          },
          child: const Text(
            "Aceptar Solicitud",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      );
    }

    Card _recicleCard(RecicleRequest reciclerequest, String? key) {
      return Card(
        color: const Color(0XF0F0F0F0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                reciclerequest.address,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              trailing: Wrap(
                spacing: 10, // space between two icons
                children: const <Widget>[
                  Icon(Icons.location_on_outlined), // icon-1 // icon-2
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
              child: const Text(
                "Referencia",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 117, 116, 116)),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
              child: Text(
                reciclerequest.reference,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
              child: _solicitudButton(reciclerequest, key),
            )
          ],
        ),
      );
    }

    Card _titleCard(bool flag) {
      return Card(
        color: const Color(0XF0F0F0F0),
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    child: Image.asset("assets/icon2.png"),
                  ),
                  title: const Text(
                    'Bienvenido',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Aqui puedes ver tus solicitudes'),
                  trailing: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        users_ref.update({"status": value});
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.yellow,
                    activeColor: Colors.black,
                  ),
                ),
              ],
            )),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
        future: users_ref.get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            if (data["status"] == true) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(children: [
                    _titleCard(isSwitched),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: FirebaseAnimatedList(
                                query: ref
                                    .orderByChild('type') // line changed
                                    .equalTo("recicle"),
                                shrinkWrap: true,
                                itemBuilder:
                                    (context, snapshot, animation, index) {
                                  RecicleRequest recicleRequest =
                                      RecicleRequest.fromJson(snapshot.value);
                                  var tmpdistance = calculateDistance(
                                      position.latitude,
                                      position.longitude,
                                      recicleRequest.lat,
                                      recicleRequest.lng);

                                  return (tmpdistance < distance)
                                      ? _recicleCard(
                                          recicleRequest, snapshot.key)
                                      : const SizedBox(height: 0);
                                })))
                  ]));
            } else {
              isSwitched = false;
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(children: [
                    _titleCard(isSwitched),
                    const Text("usuario desactivado")
                  ]));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
