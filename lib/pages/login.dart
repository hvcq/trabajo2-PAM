import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:trabajo_2/pages/principal.dart';
import 'package:trabajo_2/pages/urlPaso.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void validarDatos(String email, String password) async {
    String tituloAlert = '';
    String url = urlDePaso;
    url += '/api/usuariosApi/GetUsuario?email=';
    url += email;
    url += '&password=';
    url += password;
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode >= 200) && (response.statusCode < 400)) {
      final Map response_map = jsonDecode(response.body);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Principal(id_autor: response_map['id'], emailEmail: email, nombreNombre: response_map['nombre'])));
    } else {
      tituloAlert =
          'El email y/o contraseña ingresados no está conectado a una cuenta';
    }
    if (tituloAlert != '') {
      CoolAlert.show(
        context: context,
        backgroundColor: const Color(0xFF607D8B),
        type: CoolAlertType.warning,
        title: tituloAlert,
        text: 'Inténtelo de nuevo',
        confirmBtnText: 'Volver a intentar',
        confirmBtnColor: const Color(0xFF607D8B),
        loopAnimation: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 30,
    );
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(53),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  sizedBox,
                  const Text('Wakala APP',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  sizedBox,
                  SizedBox(
                    width: 270,
                    height: 234,
                    child:
                        Image.asset('assets/disgusting.png', fit: BoxFit.fill),
                  ),
                  sizedBox,
                  TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(40)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF607D8B)),
                          borderRadius: BorderRadius.circular(40)),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFF607D8B),
                      ),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(40)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF607D8B)),
                          borderRadius: BorderRadius.circular(40)),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF607D8B),
                      ),
                      hintText: 'Contraseña',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF607D8B),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () async {
                          if (loginController.text.isEmpty) {
                            var snackBar = const SnackBar(
                                content: Text('Debe ingresar el email'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            if (passController.text.isEmpty) {
                              var snackBar = const SnackBar(
                                  content: Text('Debe ingresar la contraseña'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              validarDatos(
                                  loginController.text, passController.text);
                            }
                          }
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                  sizedBox,
                  const Text('by Hernán Caro',
                      style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF90A4AE))),
                ],
              ),
            ),
          ),
        ));
  }
}
