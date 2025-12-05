// widgets/reporte/transaccion_card.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recetas_app/data/database/database.dart'; // Importa tu modelo Transaccione

class TransaccionCard extends StatelessWidget {
  final Transaccione transaccion;
  
  const TransaccionCard({super.key, required this.transaccion});

  // --- Helpers de Lógica y UI ---

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

  // 🟢 CONSTRUCTOR VISUAL DE DATOS (Interpreta el JSON)
  Widget _buildDetallesVisual(BuildContext context, Map<String, dynamic> data, String tipo) {
    // Se mantiene la lógica de construcción de detalles (Venta, Edición, Genérico)
    // Se recomienda mover los helpers _buildInfoRow y _buildEstadoCard aquí también
    
    // Si la lógica es muy extensa, se podría mover el detalle visual a un widget aparte
    // (ej: TransaccionDetalleVenta, TransaccionDetalleEdicion).
    
    // Implementación de VENTA
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

    // Implementación de EDICIÓN
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
    
    // Implementación de GENÉRICO (Alta, Eliminado, etc.)
    return Column(
      children: data.entries.map((entry) {
        if (entry.key == 'consumo_inventario') return const SizedBox.shrink();
        
        String label = entry.key[0].toUpperCase() + entry.key.substring(1).replaceAll(RegExp(r'(?=[A-Z])'), ' ');
        return _buildInfoRow(label, entry.value.toString(), null);
      }).toList(),
    );
  }

  // --- Helpers de Diseño de Detalles ---

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

  // 🟢 MÉTODO PARA MOSTRAR DETALLES
  void _mostrarDetallesModerno(BuildContext context, Transaccione t, Map<String, dynamic> detalles) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50, height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

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
}