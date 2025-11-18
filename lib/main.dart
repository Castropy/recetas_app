import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';
import 'package:recetas_app/screens/Screen_recetas/screen_recetas.dart';
import 'package:recetas_app/screens/detalle_receta_screen.dart';
import 'package:recetas_app/screens/pantalla_principal/pantalla_principal.dart';
import 'package:recetas_app/providers/botton_nav_provider.dart';
import 'package:recetas_app/screens/receta_form_screen.dart';
// 1. IMPORTAR LA BASE DE DATOS
import 'data/database/database.dart'; // Asegúrate que esta ruta sea correcta (ej. lib/data/database/database.dart)

void main() {
  // 2. Asegurarse que los bindings de Flutter estén inicializados
  //    antes de acceder a los directorios del sistema de archivos.
  WidgetsFlutterBinding.ensureInitialized(); 

  // 3. Crear una instancia de la base de datos.
  //    La instancia es una variable global o local para inyección.
  final AppDatabase database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        // AÑADIR EL PROVIDER DE LA BASE DE DATOS
        Provider<AppDatabase>(
          create: (_) => database, // Inyecta la instancia única
          dispose: (_, db) => db.close(), // Opcional: Cierra la conexión al desechar
        ),
        
        // Providers existentes
        ChangeNotifierProvider(
          create: (context) => BottomNavBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FormVisibilityNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => InventarioFormNotifier(
            db: context.read<AppDatabase>(),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => RecetaFormNotifier(
            db: context.read<AppDatabase>(),
          ),
        ),

        
      ],
      child: const MyApp(),
    ),
  );
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // ... (el resto de tu clase MyApp permanece igual)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetas app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      

      initialRoute: '/',
      routes: {
        '/': (context) => PantallaPrincipal(), // Tu pantalla principal
        'recetas': (context) => const ScreenRecetas(), // Ruta de listado
        RecetaFormScreen.routeName: (context) => const RecetaFormScreen(),
        DetalleRecetaScreen.routeName: (context) => const DetalleRecetaScreen(), // NUEVA RUTA DEL FORMULARIO
      },
    );  
  }
  
}