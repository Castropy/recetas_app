import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/screens/pantalla_principal/pantalla_principal.dart';
import 'package:recetas_app/providers/botton_nav_provider.dart';

void main() {
  runApp(
    MultiProvider( // Usar MultiProvider para inyectar múltiples estados
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FormVisibilityNotifier(),
        ),
        
      ],
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