// widgets/reporte/historial_list_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recetas_app/data/database/database.dart'; // Importa tu modelo Transaccione
import 'package:recetas_app/widgets/reporte/transaccion_card.dart'; // Importa el nuevo widget

class HistorialListView extends StatelessWidget {
  final List<Transaccione> transacciones;
  
  const HistorialListView({super.key, required this.transacciones});

  // Helper para generar el encabezado de la sección por día
  String _getSectionTitle(BuildContext context, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final transactionDate = DateTime(date.year, date.month, date.day);

  if (transactionDate == today) return 'Hoy';
  if (transactionDate == yesterday) return 'Ayer';

  final locale = Localizations.localeOf(context).toString(); // ej. es_VE, en_US
  return DateFormat('EEEE, d MMM y', locale).format(date);
}


  @override
  Widget build(BuildContext context) {
    String? lastDate;

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: transacciones.length,
      itemBuilder: (context, index) {
        final Transaccione transaccion = transacciones[index];
        final String currentDate = DateFormat('yyyy-MM-dd').format(transaccion.fechaHora);
        final bool showHeader = currentDate != lastDate;
        
        lastDate = currentDate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de la Fecha
            if (showHeader)
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 8.0, left: 5),
                child: Text(
                  _getSectionTitle(context, transaccion.fechaHora),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),

            // Item de Transacción (usando el widget encapsulado)
            TransaccionCard(transaccion: transaccion),
          ],
        );
      },
    );
  }
}