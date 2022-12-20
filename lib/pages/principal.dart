import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trabajo_2/dto/listadoDeWakalas.dart';
import 'package:trabajo_2/pages/detalleWakalas/detallePrincipal.dart';
import 'package:trabajo_2/pages/nuevoWakala.dart';
import 'package:trabajo_2/pages/urlPaso.dart';

class Principal extends StatefulWidget {
  final int id_autor;
  final String emailEmail;
  final String nombreNombre;
  const Principal(
      {super.key,
      required this.id_autor,
      required this.emailEmail,
      required this.nombreNombre});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late Future<List<ListadoDeWakalas>> futureListadoDeWakalas;

  @override
  void initState() {
    super.initState();
    futureListadoDeWakalas = getListadoDeWakalas();
  }

  Future<List<ListadoDeWakalas>> getListadoDeWakalas() async {
    String url = urlDePaso;
    url += '/api/wuakalasApi/Getwuakalas';
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode >= 200) && (response.statusCode < 400)) {
      //print(response.body);
      var list = listadoDeWakalasFromJson(response.body);
      return List.from(list.reversed);
    } else {
      throw Exception('Error status code ${response.statusCode}');
    }
  }

  void alertSalir(BuildContext context) {
    CoolAlert.show(
      context: context,
      showCancelBtn: true,
      backgroundColor: const Color(0xFF607D8B),
      type: CoolAlertType.warning,
      title: '¿Está seguro que desea salir?',
      confirmBtnText: 'Salir',
      confirmBtnColor: const Color(0xFF607D8B),
      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      cancelBtnText: 'Volver',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      loopAnimation: false,
    );
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
                Icons.logout,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                alertSalir(context);
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Listado de Wakalas',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        elevation: 2,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF607D8B),
        key: _refreshIndicatorKey,
        onRefresh: () async {
          futureListadoDeWakalas = getListadoDeWakalas();
          var list = await futureListadoDeWakalas;
          if (list.isNotEmpty) {
            setState(() {
              print('Recargando todo');
            });
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            alertSalir(context);
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<List<ListadoDeWakalas>>(
              future: futureListadoDeWakalas,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Colors.blueGrey[100],
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          snapshot.data![index].sector,
                          style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'por @${snapshot.data![index].autor} el ${snapshot.data![index].fecha}',
                          style: TextStyle(
                              color: Colors.blueGrey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetallePrincipal(
                                          id_autor: widget.id_autor,
                                          id_wakala: snapshot.data![index].id,
                                        )));
                            futureListadoDeWakalas = getListadoDeWakalas();
                            var list = await futureListadoDeWakalas;
                            if (list.isNotEmpty) {
                              setState(() {
                                print('Recargando todo');
                              });
                            }
                          },
                        ),
                      );
                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NuevoWakala(
                        id_autor: widget.id_autor,
                        emailEmail: widget.emailEmail,
                        nombreNombre: widget.nombreNombre,
                      )));
          futureListadoDeWakalas = getListadoDeWakalas();
          var list = await futureListadoDeWakalas;
          if (list.isNotEmpty) {
            setState(() {
              print('Recargando todo');
            });
          }
        },
        backgroundColor: const Color(0xFF607D8B),
        child: const Icon(Icons.add),
      ),
    );
  }
}
