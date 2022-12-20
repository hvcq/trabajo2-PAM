import 'dart:convert';

List<ListadoDeWakalas> listadoDeWakalasFromJson(String str) =>
    List<ListadoDeWakalas>.from(json.decode(str).map((x) => ListadoDeWakalas.fromJson(x)));

String listadoDeWakalasToJson(List<ListadoDeWakalas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListadoDeWakalas {
  ListadoDeWakalas({
    required this.autor,
    required this.fecha,
    required this.id,
    required this.sector,
  });

  String autor;
  String fecha;
  int id;
  String sector;

  factory ListadoDeWakalas.fromJson(Map<String, dynamic> json) => ListadoDeWakalas(
        autor: json["autor"],
        fecha: json["fecha"],
        id: json["id"],
        sector: json["sector"],
      );

  Map<String, dynamic> toJson() => {
        "autor": autor,
        "fecha": fecha,
        "id": id,
        "sector": sector,
      };
}
