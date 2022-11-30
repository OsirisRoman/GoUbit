import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goubi_delivery/main.dart';
import 'package:goubi_delivery/reusable/functions.dart';
import 'package:goubi_delivery/screens/cliente/backlog.dart';
import 'package:goubi_delivery/screens/cliente/chat.dart';
import 'package:goubi_delivery/screens/cliente/profile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:goubi_delivery/screens/disable.dart';
import 'package:goubi_delivery/screens/login.dart';

import 'cliente/mainClient.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.number}) : super(key: key);
  final int number;
  @override
  State<HomeScreen> createState() => _LoginScreenState();
}

GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');

class _LoginScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  int _actualPage = 0;
  final fb = FirebaseDatabase.instance;
  final List<Widget> _paginas = [
    const MainClientScreen(),
    const BacklogScreen(),
    const ChatScreen(),
    const ProfileScreen()
  ];
  Future<void> setupToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> setupLocation() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    final Position currentLocation = await determinePosition();
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'lat': currentLocation.latitude,
      'lng': currentLocation.longitude,
    });
  }

  @override
  void initState() {
    super.initState();
    setupToken();
    setupLocation();
    setState(() {
      _actualPage = widget.number;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userui = FirebaseAuth.instance.currentUser?.uid;

    final mainContainer = MaterialApp(
        title: 'Home Page',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: Scaffold(
          body: _paginas[_actualPage],
          appBar: AppBar(
            title: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 50,
            ),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: BottomNavigationBar(
              key: globalKey,
              currentIndex: _actualPage,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _actualPage = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.window), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.access_time_outlined), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.wechat_outlined), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
              ]),
        ));

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Problemas al iniciar sesion"));
          } else if (snapshot.hasData) {
            if (snapshot.data!.get("blocked") == false) {
              return mainContainer;
            } else {
              return const DisableScreen();
            }
          } else {
            return const LoginScreen();
          }
        },
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userui)
            .snapshots());
  }
}
