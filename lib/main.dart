import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; 
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'data/database/database.dart';

Future<void> main() async {
  // 1. Inicialización de bindings de Flutter
  WidgetsFlutterBinding.ensureInitialized(); 
  // 1.2. Inicialización de Google Mobile Ads
  MobileAds.instance.initialize();

  // 1.3. Configuración de orientación (Bloqueo Vertical)
  // Se usa await para asegurar que la configuración se aplique antes de lanzar la app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //1.4 It hides both the status bar (top) and navigation bar (bottom)
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual, 
    overlays: [SystemUiOverlay.top] // Only the top part remains visible
  );

  // 2. Configuración de localización y fechas
  final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale.toString();
  await initializeDateFormatting(deviceLocale, null);

  // 3. Instancia de persistencia (Data Layer)
  final AppDatabase database = AppDatabase();

  runApp(
    RecetasApp(database: database),
  );
}