import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:goubi_delivery/screens/cliente/gasClient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goubi_delivery/screens/cliente/pedido/mainOrder.dart';
import 'package:goubi_delivery/screens/cliente/recicleClient.dart';
import 'package:goubi_delivery/screens/cliente/waterClient.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainClientScreen extends StatefulWidget {
  const MainClientScreen({Key? key}) : super(key: key);

  @override
  State<MainClientScreen> createState() => _LoginScreenState();
}

final fb = FirebaseDatabase.instance;

class _LoginScreenState extends State<MainClientScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final userui = FirebaseAuth.instance.currentUser?.uid;
    final ref = fb.ref().child('deliveryProgress/$userui');
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final container = FutureBuilder<DocumentSnapshot>(
      future: users.doc(userui).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data["type"] == "gas") {
            //FirebaseMessaging.instance.subscribeToTopic('gasRequest');
            return const GasClientScreen();
          }
          if (data["type"] == "water") {
            //FirebaseMessaging.instance.subscribeToTopic('waterRequest');
            return const WaterClientScreen();
          }
          if (data["type"] == "recicle") {
            //FirebaseMessaging.instance.subscribeToTopic('recicleRequest');
            return const RecicleClientScreen();
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              (snapshot.data! as DatabaseEvent).snapshot.value != null) {
            return const MainOrderScreen();
          }
          return container;
        });
  }
}
