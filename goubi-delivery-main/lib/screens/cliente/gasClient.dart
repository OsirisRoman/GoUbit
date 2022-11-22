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

class GasClientScreen extends StatefulWidget {
  const GasClientScreen({Key? key}) : super(key: key);

  @override
  State<GasClientScreen> createState() => _HomeWidgetState();
}

late BuildContext dialogContext;
late Position position;
late double distance;

class _HomeWidgetState extends State<GasClientScreen> {
  final fb = FirebaseDatabase.instance;
  var isSwitched = true;

  Future<void> setupToken() async {
    await FirebaseMessaging.instance.subscribeToTopic('gasRequest');
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

    Future<void> acceptOrder(GasRequest gasRequest, String? key) async {
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
      final clientui = gasRequest.uid;
      DatabaseReference refClient =
          FirebaseDatabase.instance.ref("clientProgress/$clientui");
      fb.ref().child("clientProgress/$clientui").remove();
      refDelivery.update({"orderid": key, "type": "gas"}).then((_) {
        refClient.update(
            {"status": "accepted", "orderid": key, "type": "gas"}).then((_) {
          Navigator.pop(dialogContext);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainOrderScreen()),
              (route) => false);
        });
      });
    }

    Material _solicitudButton(GasRequest gasRequest, String? key) {
      return Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(5),
        color: Colors.black,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            acceptOrder(gasRequest, key);
          },
          child: const Text(
            "Aceptar Solicitud",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      );
    }

    Card _gasCard(GasRequest gasrequest, String? key) {
      return Card(
        color: const Color(0XF0F0F0F0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                gasrequest.address,
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
                gasrequest.reference,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${gasrequest.gasOrange} Cilindros"),
                        redCircle(),
                        const SizedBox(width: 10),
                        Text("${gasrequest.gasBlue} Cilindros"),
                        blueCircle(),
                      ],
                    ))),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
              child: _solicitudButton(gasrequest, key),
            )
          ],
        ),
      );
    }

    final card1 = Card(
      color: const Color(0XF0F0F0F0),
      child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  child: Image.asset("assets/icon3.png"),
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          card1,
          Expanded(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: FutureBuilder<DocumentSnapshot>(
                      future: users_ref.get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          if (data["status"] == true) {
                            return FirebaseAnimatedList(
                                query: ref
                                    .orderByChild('type') // line changed
                                    .equalTo("gas"),
                                shrinkWrap: true,
                                itemBuilder:
                                    (context, snapshot, animation, index) {
                                  GasRequest gasRequest =
                                      GasRequest.fromJson(snapshot.value);
                                  var tmpdistance = calculateDistance(
                                      position.latitude,
                                      position.longitude,
                                      gasRequest.lat,
                                      gasRequest.lng);

                                  return (tmpdistance < distance)
                                      ? _gasCard(gasRequest, snapshot.key)
                                      : const SizedBox(height: 0);
                                });
                          } else {
                            return const Text("Usuario desactivado");
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      })))
        ]));
  }
}
