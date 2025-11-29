import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'package:recetas_app/data/database/database.dart';

class ScreenReporte extends StatelessWidget {
  const ScreenReporte({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos context.read para la instancia, ya que el StreamBuilder se encarga de escuchar
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
    return DateFormat('EEEE, d MMM y', 'es').format(date); // Asegúrate de tener locale configurado si quieres español, sino usa default
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
                  _getSectionTitle(transaccion.fechaHora),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),

            // Item de Transacción
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
    
    final IconData icon = _getIcon(transaccion.tipo);
    final Color color = _getColor(transaccion.tipo);
    
    // Título Principal de la Tarjeta
    String title;
    if (transaccion.tipo == 'Venta') {
      title = 'Venta: ${detalles['receta'] ?? 'Receta #${transaccion.entidadId}'}';
    } else {
      title = '${transaccion.tipo} ${transaccion.entidad}: ${detalles['nombre'] ?? ''}';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(DateFormat('hh:mm a').format(transaccion.fechaHora)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => _mostrarDetallesModerno(context, transaccion, detalles),
      ),
    );
  }
  
  // 🟢 MÉTODO NUEVO: Muestra BottomSheet en lugar de Alert Dialog
  void _mostrarDetallesModerno(BuildContext context, Transaccione t, Map<String, dynamic> detalles) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que la hoja crezca si hay mucho contenido
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6, // Altura inicial (60% de la pantalla)
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra de agarre visual
                  Center(
                    child: Container(
                      width: 50, height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  // Cabecera del Reporte
                  Row(
                    children: [
                      Icon(_getIcon(t.tipo), color: _getColor(t.tipo), size: 30),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${t.tipo} de ${t.entidad}', 
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            Text(DateFormat('dd MMM yyyy, hh:mm a').format(t.fechaHora),
                              style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),

                  // 🟢 Contenido Visual Renderizado
                  _buildDetallesVisual(context, detalles, t.tipo),
                  
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 🟢 CONSTRUCTOR VISUAL DE DATOS (Interpreta el JSON)
  Widget _buildDetallesVisual(BuildContext context, Map<String, dynamic> data, String tipo) {
    
    // --- CASO 1: VENTA (Tabla de consumo) ---
    if (tipo == 'Venta' && data.containsKey('consumo_inventario')) {
      final listaConsumo = List<Map<String, dynamic>>.from(data['consumo_inventario']);
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Receta Vendida', data['receta'] ?? 'Desconocida', Icons.restaurant_menu),
          _buildInfoRow('Costo Producción', '\$${data['costo_produccion']}', Icons.attach_money),
          const SizedBox(height: 20),
          
          const Text('Impacto en Inventario:', 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
          const SizedBox(height: 10),
          
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listaConsumo.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final item = listaConsumo[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['ingrediente'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Stock: ${item['stock_antes']} ➔ ${item['stock_despues']}', 
                             style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text('- ${item['requerido']}', 
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      );
    }

    // --- CASO 2: EDICIÓN (Comparativa Antes vs Ahora) ---
    if (tipo == 'Edición' && data.containsKey('antes') && data.containsKey('despues')) {
      final antes = data['antes'] as Map<String, dynamic>;
      final despues = data['despues'] as Map<String, dynamic>;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cambios Realizados:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildEstadoCard('Antes', antes, Colors.orange.shade50)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              ),
              Expanded(child: _buildEstadoCard('Ahora', despues, Colors.green.shade50)),
            ],
          )
        ],
      );
    }

    // --- CASO 3: GENÉRICO (Alta, Eliminado, etc.) ---
    // Renderiza cualquier par clave-valor de forma bonita
    return Column(
      children: data.entries.map((entry) {
        // Ignoramos claves complejas que ya tratamos o no queremos mostrar crudas
        if (entry.key == 'consumo_inventario') return const SizedBox.shrink();
        
        // Formatear claves (ej: "costoUnitario" -> "Costo Unitario")
        String label = entry.key[0].toUpperCase() + entry.key.substring(1).replaceAll(RegExp(r'(?=[A-Z])'), ' ');
        return _buildInfoRow(label, entry.value.toString(), null);
      }).toList(),
    );
  }

  // --- Helpers de Diseño ---

  Widget _buildInfoRow(String label, String value, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.blueGrey), 
            const SizedBox(width: 10)
          ],
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black54))),
        ],
      ),
    );
  }

  Widget _buildEstadoCard(String titulo, Map<String, dynamic> datos, Color colorFondo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: colorFondo, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
          const Divider(),
          ...datos.entries.map((e) {
             String key = e.key == 'cant' ? 'Cantidad' : (e.key == 'costo' ? 'Costo' : e.key);
             return Padding(
               padding: const EdgeInsets.only(bottom: 4.0),
               child: Text('$key: ${e.value}', style: const TextStyle(fontSize: 13, color: Colors.black87)),
             );
          }),
        ],
      ),
    );
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'Venta': return Icons.shopping_cart;
      case 'Edición': return Icons.edit_note;
      case 'Eliminado': return Icons.delete_outline;
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
}