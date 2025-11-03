import 'package:flutter/material.dart';
import 'package:recetas_app/screens/pantalla_principal/pantalla_principal.dart';

void main() {
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
   const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetas app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaPrincipal(),
    );
  }
}