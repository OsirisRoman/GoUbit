import 'package:firebase_auth/firebase_auth.dart';
import 'package:goubi_delivery/reusable/functions.dart';
import 'package:goubi_delivery/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:goubi_delivery/screens/register.dart';

import 'Recover.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

late BuildContext dialogContext;

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Correo Electronico",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _passwordVisible,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          hintText: "Contrasena",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: Colors.black,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn();
        },
        child: const Text(
          "Iniciar Sesion",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
    final forgotPassword = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecoverScreen()),
          );
        },
        child: const Text(
          "Olvide mi contrasena",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ));
    final noAccount = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("No tengo una cuenta. "),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            child: const Text(
              "Registrarme",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            )),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 30, 0),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 130,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 80),
                      emailField,
                      const SizedBox(height: 10),
                      passwordField,
                      const SizedBox(height: 30),
                      loginButton,
                      const SizedBox(height: 15),
                      forgotPassword,
                      const SizedBox(height: 100),
                      noAccount
                    ]),
              )),
        ),
      )),
    );
  }

  Future signIn() async {
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
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((uid) => {
                if (uid.user!.emailVerified)
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen(
                                  number: 0,
                                )),
                        (route) => false)
                  }
                else
                  {
                    Navigator.pop(context),
                    FirebaseAuth.instance.signOut(),
                    showOkDialog(context, "Error",
                        "El usuario no ha verificado su email"),
                  }
              });
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      Navigator.pop(context);
      if (e.toString().contains('wrong-password')) {
        showOkDialog(
            context, "Error", "La contraseña o el usuario esta incorrecto");
      } else if (e.toString().contains('user-disabled')) {
        showOkDialog(context, "Error", "El usuario ha sido desactivado");
      } else if (e.toString().contains('user-not-found')) {
        showOkDialog(context, "Error", "El usuario no existe");
      } else {
        showOkDialog(context, "Error", e.toString());
      }
    }
  }
}
