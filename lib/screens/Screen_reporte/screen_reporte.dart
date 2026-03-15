import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class ScreenReporte extends StatelessWidget {
  const ScreenReporte({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const SafeArea(
        child: ReporteDataView(),
      ),
    );
  }
}