import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'mainChat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final userui = FirebaseAuth.instance.currentUser?.uid;
    final ref = fb.ref().child('deliveryProgress/$userui');
    final nochatBox = Scaffold(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.chat_bubble,
                        color: Color.fromARGB(255, 159, 149, 143),
                        size: 100.0,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("No tienes ningun servicio en curso"),
                    ],
                  ))),
        ));

    return StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              (snapshot.data! as DatabaseEvent).snapshot.value != null) {
            return const MainChatSreen();
          }
          return nochatBox;
        });
  }
}
