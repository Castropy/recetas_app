import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'package:recetas_app/data/database/database.dart'; 

class ScreenReporte extends StatelessWidget {
  const ScreenReporte({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones', style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 30,
          color: Color.fromARGB(255, 45, 85, 216),
        )),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Transaccione>>(
        stream: db.watchAllTransacciones(), // 🟢 Nuevo Stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay registros de transacciones.'));
          }

          final List<Transaccione> transacciones = snapshot.data!;
          return _HistorialListView(transacciones: transacciones);
        },
      ),
    );
  }
}

class _HistorialListView extends StatelessWidget {
  final List<Transaccione> transacciones;
  const _HistorialListView({required this.transacciones});

  // Helper para generar el encabezado de la sección por día
  String _getSectionTitle(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) return 'Hoy';
    if (transactionDate == yesterday) return 'Ayer';
    return DateFormat('EEEE, d MMMM y').format(date); // Ej: Miércoles, 26 Nov 2025
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
        
        // Actualizar la última fecha para la siguiente iteración
        lastDate = currentDate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Encabezado de la Fecha (Agrupación)
            if (showHeader)
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                child: Text(
                  _getSectionTitle(transaccion.fechaHora),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

            // 🟢 Item de Transacción
            _TransaccionCard(transaccion: transaccion),
          ],
        );
      },
    );
  }
}

class _TransaccionCard extends StatelessWidget {
  final Transaccione transaccion;
  const _TransaccionCard({required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> detalles = jsonDecode(transaccion.detalles);
    
    // Asigna icono y color según el tipo de transacción
    final IconData icon = _getIcon(transaccion.tipo);
    final Color color = _getColor(transaccion.tipo);
    
    // Título Principal
    String title;
    if (transaccion.tipo == 'Venta') {
      title = '🛒 Venta: ${detalles['receta']}';
    } else {
      title = '${transaccion.tipo} ${transaccion.entidad}: ${detalles['nombre'] ?? transaccion.entidadId}';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('${DateFormat('HH:mm').format(transaccion.fechaHora)} - ID # ${transaccion.entidadId}'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
        onTap: () => _mostrarDetalles(context, transaccion, detalles),
      ),
    );
  }
  
  // Helpers
  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'Venta': return Icons.point_of_sale;
      case 'Edición': return Icons.edit_note;
      case 'Eliminado': return Icons.delete_forever;
      case 'Alta': return Icons.add_circle_outline;
      default: return Icons.info_outline;
    }
  }

  Color _getColor(String tipo) {
    switch (tipo) {
      case 'Venta': return Colors.green.shade700;
      case 'Edición': return Colors.orange.shade700;
      case 'Eliminado': return Colors.red.shade700;
      case 'Alta': return Colors.blue.shade700;
      default: return Colors.grey;
    }
  }

  void _mostrarDetalles(BuildContext context, Transaccione t, Map<String, dynamic> detalles) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${t.tipo} de ${t.entidad}'),
          content: SingleChildScrollView(
            child: Text(const JsonEncoder.withIndent('  ').convert(detalles)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}