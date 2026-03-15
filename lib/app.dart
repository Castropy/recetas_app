import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recetas_app/screens/Screen_recetas/widgets/detalle_receta_screen.dart';

// Importaciones de base de datos y providers
import 'data/database/database.dart';
import 'package:recetas_app/providers/form_visibility_notifier.dart';
import 'package:recetas_app/providers/inventario_form_notifier.dart';
import 'package:recetas_app/providers/receta_form_notifier.dart';
import 'package:recetas_app/providers/search_notifier.dart';
import 'package:recetas_app/providers/vender_notifier.dart';
import 'package:recetas_app/providers/botton_nav_provider.dart';

// Pantallas
import 'package:recetas_app/screens/Screen_recetas/screen_recetas.dart';
import 'package:recetas_app/screens/pantalla_principal/pantalla_principal.dart';
import 'package:recetas_app/screens/Screen_recetas/receta_form_screen.dart';

class RecetasApp extends StatelessWidget {
  final AppDatabase database;

  const RecetasApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Inyección de la base de datos como dependencia base
        Provider<AppDatabase>(
          create: (_) => database,
          dispose: (_, db) => db.close(),
        ),
        
        // Providers que no dependen de la DB
        ChangeNotifierProvider(create: (_) => BottomNavBarProvider()),
        ChangeNotifierProvider(create: (_) => FormVisibilityNotifier()),
        ChangeNotifierProvider(create: (_) => SearchNotifier()),

        // Providers que dependen de la DB (Inyección de dependencia)
        ChangeNotifierProvider(
          create: (context) => InventarioFormNotifier(db: context.read<AppDatabase>()),
        ),
        ChangeNotifierProvider(
          create: (context) => RecetaFormNotifier(db: context.read<AppDatabase>()),
        ),
        ChangeNotifierProvider(
          create: (context) => VenderNotifier(db: context.read<AppDatabase>()),
        ),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetas App',
      theme: ThemeData(
        useMaterial3: true, // Recomendado para Flutter moderno
        colorSchemeSeed: Colors.blue,
      ),
      
      // Localización
      supportedLocales: const [
        Locale('es', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Navegación
      initialRoute: '/',
      routes: {
        '/': (context) =>  PantallaPrincipal(),
        'recetas': (context) => const ScreenRecetas(),
        RecetaFormScreen.routeName: (context) => const RecetaFormScreen(),
        DetalleRecetaScreen.routeName: (context) => const DetalleRecetaScreen(),
      },
    );
  }
}