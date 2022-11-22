import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:goubi_delivery/screens/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final TextEditingController userController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userui = FirebaseAuth.instance.currentUser?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
          hintText: "Numero de Cedula",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
    final userField = TextFormField(
      autofocus: false,
      controller: userController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        userController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastnameController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        lastnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Numero de Celular",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Apellido",
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
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          hintText: "Correo Electronico",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
    final logOutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: Colors.black,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signOut();
        },
        child: const Text(
          "Cerrar Sesion",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
    Container namefunc(firstname, lastname) {
      return Container(
        color: Colors.white,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.people),
                title: Text(
                  '$firstname $lastname',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Scaffold mainContainer(firstname, lastname) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 30, 50),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      namefunc(firstname, lastname),
                      const SizedBox(height: 15),
                      passwordField,
                      const SizedBox(height: 20),
                      logOutButton
                    ]),
              )),
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userui).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("No se pudo cargar el perfil");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("El perfil no existe en la base de datos");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          passwordController.text = data['email'];
          return mainContainer(data['name'], data['lastname']);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
