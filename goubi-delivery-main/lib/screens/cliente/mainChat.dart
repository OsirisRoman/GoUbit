import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:goubi_delivery/reusable/requests.dart';

class MainChatSreen extends StatefulWidget {
  const MainChatSreen({Key? key}) : super(key: key);

  @override
  State<MainChatSreen> createState() => _LoginScreenState();
}

late String orderid;
late DatabaseReference chatref;

class _LoginScreenState extends State<MainChatSreen> {
  final TextEditingController chatController = TextEditingController();
  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    orderid = '';
    final userui = FirebaseAuth.instance.currentUser?.uid;
    final useref = fb.ref().child('deliveryProgress/$userui');
    chatref = fb.ref().child('chats');

    final chatField = Expanded(
        child: TextFormField(
      autofocus: false,
      controller: chatController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        chatController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Envie Mensaje",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    ));

    final sendText = SizedBox(
        width: 60,
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0XF0F0F0F0),
          child: MaterialButton(
            minWidth: 10,
            onPressed: () async {
              await _sendMessage();
            },
            child: const Icon(Icons.send_sharp),
          ),
        ));
    final chatForm = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [chatField, const SizedBox(width: 5), sendText],
    );
    Container createChatDialog(ChatRequest chatrequest) {
      return Container(
        margin: chatrequest.type == "delivery"
            ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
            : const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        decoration: BoxDecoration(
            color: chatrequest.type == "delivery"
                ? const Color.fromARGB(255, 242, 240, 240)
                : const Color.fromARGB(255, 194, 193, 193),
            borderRadius: chatrequest.type == "delivery"
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0))
                : const BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0))),
        child: Text(chatrequest.text),
      );
    }

    Scaffold createChatBox(String orderid) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(children: [
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: FirebaseAnimatedList(
                            query: fb.ref().child('chats/$orderid'),
                            shrinkWrap: true,
                            sort: (a, b) => (b.key!.compareTo(a.key!)),
                            reverse: true,
                            itemBuilder: (context, snapshot, animation, index) {
                              ChatRequest chatRequest =
                                  ChatRequest.fromJson(snapshot.value);
                              return createChatDialog(chatRequest);
                            }))),
                chatForm
              ])));
    }

    return FutureBuilder<DataSnapshot>(
        future: useref.get(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            OrderRequest orderrequest =
                OrderRequest.fromJson(snapshot.data?.value);
            orderid = orderrequest.orderid;
            return createChatBox(orderrequest.orderid);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<void> _sendMessage() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    await chatref
        .child("$orderid/$timestamp")
        .update({"text": chatController.text, "type": "delivery"}).then((_) {
      chatController.text = '';
      FocusManager.instance.primaryFocus?.unfocus();
    }).catchError((error) {
      // The write failed...
    });
  }
}
