import 'package:firebase_core/firebase_core.dart'; // Para la inicialización de Firebase
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'firebase_options.dart'; // Importa el archivo generado

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Usa las opciones generadas
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ventas Bodega',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Puedes personalizar el tema aquí
      ),
      home: HomeScreen(), // Pantalla inicial, que es donde mostrarás las ventas
    );
  }
}
