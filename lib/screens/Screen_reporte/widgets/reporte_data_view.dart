import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'historial_list_view.dart';
import 'reporte_empty_state.dart';

class ReporteDataView extends StatelessWidget {
  const ReporteDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return StreamBuilder<List<Transaccione>>(
      stream: db.transaccionesDao.watchAllTransacciones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const ReporteEmptyState();
        }

        final transacciones = snapshot.data!;
        
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: HistorialListView(transacciones: transacciones),
        );
      },
    );
  }
}