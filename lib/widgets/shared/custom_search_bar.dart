import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/search_notifier.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  // 1. El controlador se declara AQUÍ, fuera del build.
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 2. Inicializamos el controlador con el valor actual del provider
    final initialQuery = context.read<SearchNotifier>().query;
    _controller = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    // 3. ¡Importante! Limpiar el controlador al destruir el widget
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mapeo para nombres amigables
    final Map<SearchFilter, String> filterNames = {
      SearchFilter.nombre: 'Nombre',
      SearchFilter.id: 'ID',
      SearchFilter.precio: 'Precio',
    };

    // Usamos select para que este widget SOLO se reconstruya si cambia el FILTRO 
    // o si la QUERY se limpia externamente, pero no en cada letra.
    final currentFilter = context.select((SearchNotifier n) => n.filter);
    final isQueryEmpty = context.select((SearchNotifier n) => n.query.isEmpty);

    // Si alguien limpia la búsqueda desde fuera, actualizamos el texto visual
    if (isQueryEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onTapOutside: (event) {
             FocusScope.of(context).unfocus();
            },
            controller: _controller, // 4. Usamos el controlador persistente
            decoration: InputDecoration(
              hintText: 'Buscar por ${filterNames[currentFilter]}...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: !isQueryEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchNotifier>().clearSearch();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            ),
            onChanged: (value) {
              // 5. Solo enviamos el cambio al notifier, sin reconstruir este TextField
              context.read<SearchNotifier>().updateSearch(value, currentFilter);
            },
          ),
          
          const SizedBox(height: 8),

          // Chips de Filtro
          Row(
            children: SearchFilter.values.map((filter) {
              final isSelected = currentFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ChoiceChip(
                  label: Text(filterNames[filter]!),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) {
                      context.read<SearchNotifier>().updateSearch(_controller.text, filter);
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}