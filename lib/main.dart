import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/screens/pantalla_principal/pantalla_principal.dart';
import 'package:recetas_app/screens/widgets/common/botton_navigation_bar.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BottomNavBarProvider(),
      child: MyApp(),
    ),
  );
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