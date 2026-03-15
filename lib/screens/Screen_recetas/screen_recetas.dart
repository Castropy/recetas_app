import 'package:flutter/material.dart';
import 'package:recetas_app/screens/Screen_recetas/receta_form_screen.dart';

// Importación única mediante el Barrel File local
import 'widgets/widgets.dart'; 
// Widgets compartidos
import 'package:recetas_app/widgets/shared/custom_search_bar.dart';

/// Pantalla principal del catálogo de Recetas.
/// 
/// Utiliza una arquitectura modular donde la lógica de visualización 
/// y los componentes individuales están delegados a [RecetaDataView].
class ScreenRecetas extends StatelessWidget {
  const ScreenRecetas({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recetas',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: Color.fromARGB(255, 45, 85, 216),
          ),
        ),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          // Barra de búsqueda global
          CustomSearchBar(),
          
          // Vista principal de datos (Stream, filtros y lista)
          Expanded(child: RecetaDataView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        heroTag: 'addRecetaButton',
        backgroundColor: theme.colorScheme.primary,
        onPressed: () => Navigator.pushNamed(context, RecetaFormScreen.routeName),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}