import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:goubi_delivery/reusable/functions.dart';
import 'package:goubi_delivery/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_textfield/dropdown_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

late BuildContext dialogContext;

class _LoginScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  final TextEditingController userController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late SingleValueDropDownController _cnt;

  @override
  void dispose() {
    userController.dispose();
    nameController.dispose();
    cedulaController.dispose();
    placaController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _cnt.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
  }

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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Correo incompleto ';
        } else if (!value.contains('@') || !value.contains(".")) {
          return "Ingrese un correo valido";
        }
        return null;
      },
    );
    final phoneField = TextFormField(
      autofocus: false,
      controller: userController,
      keyboardType: TextInputType.phone,
      onSaved: (value) {
        userController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Numero de Telefono",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Telefono incompleto ';
        } else if (value.length != 10) {
          return 'Ingrese un telefono de 10 digitos ';
        }
        return null;
      },
    );
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastnameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        lastnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Apellido",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Apellido incompleto ';
        }
        return null;
      },
    );
    final cedulaField = TextFormField(
      autofocus: false,
      controller: cedulaController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        cedulaController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Numero de cedula",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'cedula incompleta ';
        }
        var c = verificar(value);
        if (c == '1') {
          return null;
        }
        return 'Cedula no existe';
      },
    );
    final placaField = TextFormField(
      autofocus: false,
      controller: placaController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        placaController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Ingrese Placa",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Placa incompleta ';
        } else if (value.length != 6 || value.length != 7) {
          return 'Ingrese un telefono de 10 digitos ';
        }
      },
    );
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          //prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nombre incompleto';
        }
        return null;
      },
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Contrasena incompleta';
        }
        return null;
      },
    );

    final dropDown = DropDownTextField(
      controller: _cnt,
      clearOption: false,
      textFieldDecoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          hintText: "Roll de repartidor",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      enableSearch: true,
      searchDecoration: const InputDecoration(hintText: "Seleccione un roll"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Seleccione una opcion";
        } else {
          return null;
        }
      },
      dropDownItemCount: 3,
      dropDownList: const [
        DropDownValueModel(name: 'Repartidor de Gas', value: "gas"),
        DropDownValueModel(name: 'Repartidor de Agua', value: "water"),
        DropDownValueModel(name: 'Reciclador', value: "recicle"),
      ],
      onChanged: (val) {},
    );
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: Colors.black,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await _registerUser(context);
          }
        },
        child: const Text(
          "Registrarme",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 30, 50),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 120,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      dropDown,
                      const SizedBox(height: 15),
                      nameField,
                      const SizedBox(height: 15),
                      lastNameField,
                      const SizedBox(height: 15),
                      phoneField,
                      const SizedBox(height: 15),
                      cedulaField,
                      const SizedBox(height: 15),
                      placaField,
                      const SizedBox(height: 15),
                      emailField,
                      const SizedBox(height: 15),
                      passwordField,
                      const SizedBox(height: 10),
                      loginButton,
                    ]),
              )),
        ),
      )),
    );
  }

  Future _registerUser(BuildContext context) async {
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
    createUser().then((response) => {
          Navigator.pop(dialogContext),
          showAlertDialog(context, response.body)
        });
  }

  showAlertDialog(BuildContext context, String body) {
    var json = convert.jsonDecode(body) as Map<dynamic, dynamic>;
    var showtext = 'Some Error';
    print(json);
    if (json['sucess']) {
      showtext = 'usuario creado con exito';
    } else {
      var codeError = json['error']['code'];
      if (codeError == "auth/invalid-phone-number") {
        showtext = 'Ingresa un formato de telfono correcto +593';
      }
      if (codeError == "auth/email-already-exists") {
        showtext = 'El correo ya existe en otro usuario';
      }
      if (codeError == "auth/phone-number-already-exists") {
        showtext = 'El telefono ya existe en otro usuario';
      }
      if (codeError == "noenoughLen") {
        showtext = 'Ingrese un numero de 10 digitos';
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(json['sucess'] ? 'Exito' : 'Error'),
          content: Text(showtext),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<http.Response> createUser() {
    return http.post(
      Uri.parse(
          'https://us-central1-goubi-360003.cloudfunctions.net/onCreateUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'api-key': 'a9c492c3f5b149ec8a3fea1775c4f95f'
      },
      body: convert.jsonEncode(<String, String>{
        "firstname": nameController.text,
        "lastname": lastnameController.text,
        "placa": placaController.text,
        "cedula": cedulaController.text,
        "email": emailController.text,
        "phone": userController.text,
        "type": _cnt.dropDownValue?.value,
        "password": passwordController.text
      }),
    );
  }
}
