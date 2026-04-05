import 'package:flutter/material.dart';

class AppGuideWidget extends StatelessWidget {
  const AppGuideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.auto_stories, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  "Guía rápida de uso",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildGuideSection(
            context,
            icon: Icons.inventory_2_outlined,
            title: "¿Cómo usar el inventario?",
            content: [
              "• Despliega el menú y presiona 'Inventario'.",
              "• Dale al botón '+'.",
              "• Selecciona unidad: Gramos, ML o Unids.",
              "• Cantidad total: Ej. si compraste 5kg o 5Litros, coloca '5000'.",
              "• Precio: Por KILO o LITRO.",
              "• Precio: No importa si compraste mas de 1 kilo o litro siempre coloca precio por 1 kg o 1 Litro",
              "• Si el precio es por unidad coloca el precio total del bulto",
              "•Si es un precio con decimales usa punto (.) en lugar de coma (,). Ej. 12.50",
              "• Dale al botón verde 'Guardar'.",
            ],
          ),
          _buildGuideSection(
            context,
            icon: Icons.restaurant_menu,
            title: "¿Cómo crear una receta?",
            content: [
              "• Ve a 'Recetas' y presiona '+'.",
              "• Ingresa el nombre y selecciona los ingredientes.",
              "• Define la cantidad necesaria (ej. 300g de harina).",
              "• La app calculará automáticamente el costo.",
            ],
          ),
          _buildGuideSection(
            context,
            icon: Icons.point_of_sale,
            title: "¿Cómo registro mis ventas?",
            content: [
              "• En 'Vender', selecciona las recetas y presiona el botón.",
              "• Si el inventario es insuficiente, la app no permitirá la venta para proteger tu control real.",
            ],
          ),
          _buildGuideSection(
            context,
            icon: Icons.bar_chart,
            title: "¿Cómo veo mi historial?",
            content: [
              "• En 'Reportes' verás: Altas, Ediciones, Bajas y Ventas.",
              "• Presiona una Venta para ver impacto en inventario.",
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(BuildContext context,
      {required IconData icon, required String title, required List<String> content}) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 55, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content
                .map((text) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}