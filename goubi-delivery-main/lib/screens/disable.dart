import 'package:firebase_auth/firebase_auth.dart';
import 'package:goubi_delivery/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:goubi_delivery/screens/login.dart';
import 'package:goubi_delivery/screens/register.dart';

import 'Recover.dart';

class DisableScreen extends StatefulWidget {
  const DisableScreen({Key? key}) : super(key: key);

  @override
  State<DisableScreen> createState() => _LoginScreenState();
}

late BuildContext dialogContext;

class _LoginScreenState extends State<DisableScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
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
            const Text("El usuario ha sido desactivado"),
          ])),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
            FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ],
    );
  }
}
