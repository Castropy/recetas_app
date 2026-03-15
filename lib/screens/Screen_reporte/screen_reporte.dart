import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/screens/Screen_reporte/widgets/historial_list_view.dart'; 

class ScreenReporte extends StatelessWidget {
  const ScreenReporte({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial', 
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: Color.fromARGB(255, 45, 85, 216),
          ),
        ),
        centerTitle: true,
      ),
      // SafeArea añadido para proteger el contenido en dispositivos con gestos o bordes curvos
      body: SafeArea(
        child: StreamBuilder<List<Transaccione>>(
          stream: db.transaccionesDao.watchAllTransacciones(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // LayoutBuilder para que el estado vacío ocupe todo el espacio sin overflows
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_toggle_off_rounded, 
                          size: 80, 
                          color: theme.colorScheme.primary
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay registros de transacciones aún.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18, 
                            color: Colors.grey,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final List<Transaccione> transacciones = snapshot.data!;
            
            // Reforzamos la lista con un scroll fluido
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: HistorialListView(transacciones: transacciones),
            );
          },
        ),
      ),
    );
  }
}