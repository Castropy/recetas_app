import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/providers/search_notifier.dart'; // Importamos el nuevo Provider

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos solo para obtener la query y el filtro actual (para hint y chips)
    final searchNotifier = context.watch<SearchNotifier>(); 
    // Usamos .read para llamar a updateSearch/clearSearch, aunque watch también funciona.
    final notifierWriter = context.read<SearchNotifier>(); 

    final TextEditingController controller = TextEditingController(text: searchNotifier.query);
    
    // Mapeo para nombres amigables de los filtros
    final Map<SearchFilter, String> filterNames = {
      SearchFilter.nombre: 'Nombre',
      SearchFilter.id: 'ID',
      SearchFilter.precio: 'Precio',
    };

    // Usamos el estado local del campo (controller) solo para la limpieza
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          // 1. Campo de Texto (Busca)
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Buscar por ${filterNames[searchNotifier.filter]}...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchNotifier.query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear(); // Limpia la visual
                        notifierWriter.clearSearch(); // Limpia el estado
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
            // 🟢 Actualiza el Notifier con cada cambio
            onChanged: (value) => notifierWriter.updateSearch(value, searchNotifier.filter),
          ),
          
          const SizedBox(height: 8),

          // 2. Chips de Filtro (Selector)
          Row(
            children: SearchFilter.values.map((filter) {
              final isSelected = searchNotifier.filter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ChoiceChip(
                  label: Text(filterNames[filter]!),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) {
                      // 🟢 Actualiza el Notifier con el nuevo filtro
                      notifierWriter.updateSearch(searchNotifier.query, filter);
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.black,
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