import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trabajo_2/pages/urlPaso.dart';

class ComentarWakala extends StatefulWidget {
  final int id_autor;
  final int id_wuakala;
  final String sector;
  const ComentarWakala(
      {super.key,
      required this.id_autor,
      required this.id_wuakala,
      required this.sector});

  @override
  State<ComentarWakala> createState() => _ComentarWakalaState();
}

class _ComentarWakalaState extends State<ComentarWakala> {
  void crearMensaje(String descripcion) async {
    String url = '$urlDePaso/api/comentariosApi/Postcomentario/';

    var res = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_wuakala': widget.id_wuakala.toString(),
        'descripcion': descripcion,
        'id_autor': widget.id_autor.toString(),
      }),
    );
    Timer(Duration(seconds: 3), () {
      setState(() {
        Navigator.pop(context);
        print(res.statusCode);
        Navigator.pop(context);
      });
    });
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        centerTitle: true,
        title: Text(
          widget.sector,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF607D8B)),
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Escriba aquí su comentario...',
                ),
                maxLines: 10,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una descripción';
                  }
                  if (value.length < 15) {
                    return 'Debe ingresar al menos 15 caracteres';
                  }
                  return null;
                },
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF607D8B),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Container(
                              padding: const EdgeInsets.all(16),
                              height: 200,
                              width: 200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF607D8B),
                                )
                              )
                            ),
                      ));
                      crearMensaje(descripcionController.text);
                    }
                  },
                  child: const Text(
                    'Comentar Wakala',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF),
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Color(0xFF90A4AE), width: 1),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Me Arrepentí',
                    style: TextStyle(color: Color(0xFF90A4AE), fontSize: 22),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
