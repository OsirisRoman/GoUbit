import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:goubi_delivery/reusable/requests.dart';
import 'package:goubi_delivery/screens/cliente/pedido/gasOrder.dart';
import 'package:goubi_delivery/screens/cliente/pedido/recicleOrder.dart';
import 'package:goubi_delivery/screens/cliente/pedido/waterOrder.dart';

class MainOrderScreen extends StatefulWidget {
  const MainOrderScreen({Key? key}) : super(key: key);

  @override
  State<MainOrderScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<MainOrderScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final userui = FirebaseAuth.instance.currentUser?.uid;
    final ref = fb.ref().child('deliveryProgress/$userui');
    return FutureBuilder<DataSnapshot>(
        future: ref.get(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            OrderRequest orderrequest =
                OrderRequest.fromJson(snapshot.data?.value);

            if (orderrequest.type == "gas") {
              return GasOrderScreen(id: orderrequest);
            }
            if (orderrequest.type == "water") {
              return WaterOrderScreen(id: orderrequest);
            }
            if (orderrequest.type == "recicle") {
              return RecicleOrderScreen(id: orderrequest);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
