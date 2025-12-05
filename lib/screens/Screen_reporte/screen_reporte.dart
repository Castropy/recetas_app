// screen_reporte.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart'; // Tu base de datos y modelo Transaccione
// 🟢 Importar los nuevos widgets encapsulados
import 'package:recetas_app/widgets/reporte/historial_list_view.dart'; 

class ScreenReporte extends StatelessWidget {
  const ScreenReporte({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial', style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 30,
          color: Color.fromARGB(255, 45, 85, 216),
        )),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Transaccione>>(
        stream: db.watchAllTransacciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('No hay registros de transacciones.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final List<Transaccione> transacciones = snapshot.data!;
          // 🟢 Usar el nuevo widget HistorialListView
          return HistorialListView(transacciones: transacciones);
        },
      ),
    );
  }
}