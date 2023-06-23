import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_application_api2/screen/home.dart';

// Clase personalizada que hereda de HttpOverrides para personalizar el comportamiento de las solicitudes HTTP
class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    // Se crea un objeto HttpClient personalizado
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    // La propiedad badCertificateCallback se establece para aceptar todos los certificados sin validarlos
    // Esto puede ser útil en casos en los que se necesite realizar solicitudes a servidores con certificados autofirmados o no válidos.
  }
}

void main() {
  // Se establece la clase PostHttpOverrides como la implementación global de HttpOverrides
  HttpOverrides.global = new PostHttpOverrides();

  // Se inicia la aplicación Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la bandera de depuración en la esquina superior derecha de la pantalla
      home: HomeScreen(), // Establece HomeScreen() como la página principal de la aplicación
    );
  }
}
