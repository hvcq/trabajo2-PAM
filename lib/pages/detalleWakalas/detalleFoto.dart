import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetalleFoto extends StatefulWidget {
  final String url_foto;
  const DetalleFoto({super.key, required this.url_foto});
  @override
  State<DetalleFoto> createState() => _DetalleFotoState();
}

class _DetalleFotoState extends State<DetalleFoto> {
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
      body: Center(
        child: PhotoView(
            imageProvider: NetworkImage(widget.url_foto),
        ),
      ),
    );
  }
}
