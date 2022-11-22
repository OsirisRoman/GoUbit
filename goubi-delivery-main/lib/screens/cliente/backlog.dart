import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goubi_delivery/reusable/functions.dart';
import 'package:goubi_delivery/reusable/requests.dart';

class BacklogScreen extends StatefulWidget {
  const BacklogScreen({Key? key}) : super(key: key);

  @override
  State<BacklogScreen> createState() => _HomeWidgetState();
}

late Query orders;

class _HomeWidgetState extends State<BacklogScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userui = FirebaseAuth.instance.currentUser?.uid;
    orders = FirebaseFirestore.instance
        .collection('orders')
        .where('dui', isEqualTo: userui);
    final reference = Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
      child: const Text(
        "Referencia",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 117, 116, 116)),
      ),
    );
    Container setLabelName(String label) {
      return Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 20, 10),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
      );
    }

    Container setReference(String reference) {
      return Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
        child: Text(
          reference,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      );
    }

    Container setDate(String date) {
      return Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
        child: Text(
          date,
          style: const TextStyle(fontSize: 17, color: Colors.black),
        ),
      );
    }

    ListTile setTitle(String title) {
      return ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: Wrap(
          spacing: 10, // space between two icons
          children: const <Widget>[
            Icon(Icons.location_on_outlined), // icon-1 // icon-2
          ],
        ),
      );
    }

    Card _gasCard(GasRequest gasrequest, String date, String labeltext) {
      return Card(
        color: const Color(0XF0F0F0F0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            setTitle(gasrequest.address),
            reference,
            setReference(gasrequest.reference),
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
            setLabelName(labeltext),
            setDate(date)
          ],
        ),
      );
    }

    Card _waterCard(WaterRequest waterequest, String date, String labeltext) {
      return Card(
        color: const Color(0XF0F0F0F0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            setTitle(waterequest.address),
            reference,
            setReference(waterequest.reference),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                width: 1000,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Text("${waterequest.waterBottle} Botellones"),
                )),
            setLabelName(labeltext),
            setDate(date)
          ],
        ),
      );
    }

    Card _recicleCard(
        RecicleRequest reciclerequest, String date, String labeltext) {
      return Card(
        color: const Color(0XF0F0F0F0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            setTitle(reciclerequest.address),
            reference,
            setReference(reciclerequest.reference),
            setLabelName(labeltext),
            setDate(date)
          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: orders.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                String reference = data['reference'];
                String uid = data['uid'];
                String address = data['address'];
                String type = data['type'];
                double lat = data['lat'];
                double lng = data['lng'];
                String labelText = '';
                if (data['clientCancel'] == true) {
                  labelText = 'Cancelado por el usuario';
                }
                if (data['deliveryCancel'] == true) {
                  labelText = 'Cancelado por el delivery';
                }
                if (data['complete'] == true) {
                  labelText = 'Orden Completada';
                }

                if (type == "gas") {
                  GasRequest gasrequest = GasRequest(reference, uid, address,
                      data["gasOrange"], data["gasBlue"], type, lat, lng);
                  return _gasCard(gasrequest, data["date"], labelText);
                } else if (type == "water") {
                  WaterRequest waterrequest = WaterRequest(reference, uid,
                      address, data["waterBottle"], type, lat, lng);
                  return _waterCard(waterrequest, data["date"], labelText);
                } else if (type == "recicle") {
                  RecicleRequest reciclerequest =
                      RecicleRequest(reference, uid, address, type, lat, lng);
                  return _recicleCard(reciclerequest, data["date"], labelText);
                }
                return Text("wrong text");
              }).toList(),
            ));
      },
    );
    ;
  }
}
