import 'package:flutter_test/flutter_test.dart';

// Importamos la nueva ubicación de la app y la base de datos
import 'package:recetas_app/app.dart';
import 'package:recetas_app/data/database/database.dart';

void main() {
  testWidgets('RecetasApp smoke test', (WidgetTester tester) async {
    // 1. Creamos una instancia de la base de datos para el test.
    final database = AppDatabase();

    // 2. Construimos nuestra aplicación inyectando la dependencia.
    // Usamos RecetasApp en lugar de MyApp.
    await tester.pumpWidget(RecetasApp(database: database));

  });
}