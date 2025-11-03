import 'package:flutter/material.dart';
import 'package:recetas_app/screens/widgets/common/botton_navigation_bar.dart';

class PantallaPrincipal extends StatelessWidget {
   const PantallaPrincipal({super.key}); 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Recetas App')),
      ),
      body: const Center(
        child: Text('Bienvenido a la Pantalla Principal'),
      ),
       
      bottomNavigationBar: const BottonNavigationBar(),
    );
  }


}