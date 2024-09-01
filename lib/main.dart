import 'package:flutter/material.dart';
import 'package:streams_app/widgets/lista_streams.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista Streams',
        home: ListaStreams());
  }
}
