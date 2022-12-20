import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trabajo_2/pages/detalleWakalas/comentarWakala.dart';
import 'package:trabajo_2/pages/detalleWakalas/detalleFoto.dart';
import 'package:trabajo_2/pages/urlPaso.dart';

class DetallePrincipal extends StatefulWidget {
  final int id_autor;
  final int id_wakala;
  const DetallePrincipal(
      {super.key, required this.id_autor, required this.id_wakala});

  @override
  State<DetallePrincipal> createState() => _DetallePrincipalState();
}

class _DetallePrincipalState extends State<DetallePrincipal> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late Future<Map<String, dynamic>> futureDetalleWakala;

  @override
  void initState() {
    super.initState();
    futureDetalleWakala = getDetalleWakala();
  }

  Future<Map<String, dynamic>> getDetalleWakala() async {
    String url = urlDePaso;
    url += '/api/wuakalasApi/Getwuakala?id=';
    url += widget.id_wakala.toString();
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode < 200) && (response.statusCode >= 400)) {
      throw Exception('Error status code${response.statusCode}');
    } else {
      //print(response.body);
      return jsonDecode(response.body);
    }
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
          '',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        elevation: 2,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF607D8B),
        key: _refreshIndicatorKey,
        onRefresh: () async {
          futureDetalleWakala = getDetalleWakala();
          var detalle = await futureDetalleWakala;
          if (detalle.isNotEmpty) {
            setState(() {
              print('Recargando todo');
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: FutureBuilder<Map<String, dynamic>>(
              future: futureDetalleWakala,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> comentariosDynamic = snapshot.data!['comentarios'];
                  comentariosDynamic = List.from(comentariosDynamic.reversed);
                  List<Widget> comentariosWidgets = [];
                  for (var element in comentariosDynamic) {
                    comentariosWidgets.add(cuadro(element));
                    comentariosWidgets.add(const SizedBox(
                      height: 10,
                    ));
                  }
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data!['sector'].toString(),
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          height: 14,
                          thickness: 0.2,
                          color: Colors.black,
                        ),
                        Text(snapshot.data!['descripcion'].toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (snapshot.data!['url_foto1'].toString() !=
                                    '') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetalleFoto(
                                                url_foto:
                                                    '$urlDePaso/images/${snapshot.data!['url_foto1']}',
                                              )));
                                }
                              },
                              child: Container(
                                width: 180,
                                height: 190,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: snapshot.data!['url_foto1'].toString() ==
                                        ''
                                    ? Image.asset('assets/no-photo.png')
                                    : Image.network(
                                        '$urlDePaso/images/${snapshot.data!['url_foto1']}'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (snapshot.data!['url_foto2'].toString() !=
                                    '') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetalleFoto(
                                                url_foto:
                                                    '$urlDePaso/images/${snapshot.data!['url_foto2']}',
                                              )));
                                }
                              },
                              child: Container(
                                width: 180,
                                height: 190,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: snapshot.data!['url_foto2'].toString() ==
                                        ''
                                    ? Image.asset('assets/no-photo.png')
                                    : Image.network(
                                        '$urlDePaso/images/${snapshot.data!['url_foto2']}'),
                              ),
                            ),
                          ],
                        ),
                        Text(
                            'Subido por @${snapshot.data!['autor']} el ${snapshot.data!['fecha_publicacion']}'),
                        const Divider(
                          height: 14,
                          thickness: 0.2,
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: (() async {
                                  var res = await http.put(
                                    Uri.parse(
                                        '$urlDePaso/api/wuakalasApi/PutSigueAhi?id=${widget.id_wakala}'),
                                  );
                                  print(res.statusCode);
                                  futureDetalleWakala = getDetalleWakala();
                                  var detalle = await futureDetalleWakala;
                                  if (detalle.isNotEmpty) {
                                    setState(() {
                                      print('Recargando todo');
                                    });
                                  }
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF607D8B),
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  '+ Sigue ahí (${snapshot.data!['sigue_ahi']})',
                                  style: const TextStyle(fontSize: 18),
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                onPressed: (() async {
                                  var res = await http.put(
                                    Uri.parse(
                                        '$urlDePaso/api/wuakalasApi/PutYanoEsta?id=${widget.id_wakala}'),
                                  );
                                  print(res.statusCode);
                                  futureDetalleWakala = getDetalleWakala();
                                  var detalle = await futureDetalleWakala;
                                  if (detalle.isNotEmpty) {
                                    setState(() {
                                      print('Recargando todo');
                                    });
                                  }
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF607D8B),
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  '+ Ya no está (${snapshot.data!['ya_no_esta']})',
                                  style: const TextStyle(fontSize: 18),
                                )),
                          ],
                        ),
                        const Divider(
                          height: 14,
                          thickness: 0.2,
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Comentarios',
                              style: TextStyle(fontSize: 22),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ComentarWakala(
                                                id_autor: widget.id_autor,
                                                id_wuakala:
                                                    snapshot.data!['id'],
                                                sector:
                                                    snapshot.data!['sector'],
                                              )));
                                  futureDetalleWakala = getDetalleWakala();
                                  var detalle = await futureDetalleWakala;
                                  if (detalle.isNotEmpty) {
                                    setState(() {
                                      print('Recargando todo');
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E88E5),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text('Comentar')),
                          ],
                        ),
                        Column(
                          children: comentariosWidgets,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFF607D8B),
                    )));
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget cuadro(Map element) {
    return Card(
      elevation: 2.5,
      shadowColor: Colors.blueGrey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${element['descripcion']}\n',
                textAlign: TextAlign.justify,
              ),
              Text(
                '@${element['autor']} el ${element['fecha_comentario']}',
                textAlign: TextAlign.right,
              ),
            ]),
      ),
    );
  }
}
