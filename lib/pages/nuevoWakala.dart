import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:trabajo_2/utils/utiles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:trabajo_2/pages/urlPaso.dart';

class NuevoWakala extends StatefulWidget {
  final int id_autor;
  final String emailEmail;
  final String nombreNombre;
  const NuevoWakala(
      {super.key,
      required this.id_autor,
      required this.emailEmail,
      required this.nombreNombre});

  @override
  State<NuevoWakala> createState() => _NuevoWakalaState();
}

class _NuevoWakalaState extends State<NuevoWakala> {
  TextEditingController sectorController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  Future<http.Response>? _futureMensaje;

  final imagePicker1 = ImagePicker();
  final imagePicker2 = ImagePicker();

  late File? _image1 = null;
  late File? _image2 = null;

  final _formKey = GlobalKey<FormState>();

  bool boton_agregar1 = true;
  bool boton_agregar2 = true;
  bool boton_borrar1 = false;
  bool boton_borrar2 = false;

  Future getImage1() async {
    final image = await imagePicker1.getImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      try {
        _image1 ??= File(image!.path);
      } catch (e) {
        print("error");
      }
      if (_image1 != null) {
        boton_agregar1 = false;
        boton_borrar1 = true;
      } else {
        boton_agregar1 = true;
        boton_borrar1 = false;
      }
    });
  }

  Future getImage2() async {
    final image = await imagePicker2.getImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      try {
        _image2 ??= File(image!.path);
      } catch (e) {
        print("error");
      }
      if (_image2 != null) {
        boton_agregar2 = false;
        boton_borrar2 = true;
      } else {
        boton_agregar2 = true;
        boton_borrar2 = false;
      }
    });
  }

  void crearMensaje(
      String sector, String descripcion, String ruta1, String ruta2) async {
    String url = '$urlDePaso/api/wuakalasApi/Postwuakalas/';

    var res = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sector': sector,
        'descripcion': descripcion,
        'id_autor': widget.id_autor.toString(),
        'base64Foto1': await Utiles().toBase64(ruta1),
        'base64Foto2': await Utiles().toBase64(ruta2),
      }),
    );
    Timer(Duration(seconds: 3), () {
      setState(() {
        Navigator.pop(context);
        print(res.statusCode);
        Navigator.pop(context);
      });
    });
    //var res = await http.delete(Uri.parse('$urlDePaso/api/wuakalasApi/Deletewuakalas?id=90'));
    //print('delete 90: ${res.statusCode}');
  }

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
        title: const Text(
          'Avisar por nuevo Wakala',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: sectorController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF607D8B)),
                      borderRadius: BorderRadius.circular(20)),
                  suffixIcon: const Icon(
                    Icons.place,
                    color: Color(0xFF607D8B),
                  ),
                  hintText: 'Sector',
                  hintStyle: const TextStyle(fontSize: 20),
                ),
                style: const TextStyle(fontSize: 20),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre del sector';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
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
                  hintText: 'Descripción',
                ),
                maxLines: 5,
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: boton_agregar1
                              ? (() {
                                  getImage1();
                                })
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Agregar Foto 1')),
                      Container(
                        width: 190,
                        height: 200,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: _image1 == null
                            ? Image.asset('assets/no-photo.png')
                            : Image.file(_image1!),
                      ),
                      ElevatedButton(
                        onPressed: boton_borrar1
                            ? (() {
                                setState(() {
                                  _image1 = null;
                                  boton_borrar1 = false;
                                  boton_agregar1 = true;
                                });
                              })
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Borrar'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: boton_agregar2
                              ? (() {
                                  getImage2();
                                })
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Agregar Foto 2')),
                      Container(
                        width: 190,
                        height: 200,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: _image2 == null
                            ? Image.asset('assets/no-photo.png')
                            : Image.file(_image2!),
                      ),
                      ElevatedButton(
                        onPressed: boton_borrar2
                            ? (() {
                                setState(() {
                                  _image2 = null;
                                  boton_borrar2 = false;
                                  boton_agregar2 = true;
                                });
                              })
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Borrar'),
                      ),
                    ],
                  ),
                ],
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
                    if ((_image1 == null) && (_image2 == null)) {
                      var snackBar = const SnackBar(
                          content: Text('Debe agregar al menos una foto'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
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
                                      ))),
                                ));
                        if (_image1 == null) {
                          crearMensaje(sectorController.text,
                              descripcionController.text, '', _image2!.path);
                        } else if (_image2 == null) {
                          crearMensaje(sectorController.text,
                              descripcionController.text, _image1!.path, '');
                        } else {
                          crearMensaje(
                              sectorController.text,
                              descripcionController.text,
                              _image1!.path,
                              _image2!.path);
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Reportar Wakala',
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
