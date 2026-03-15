import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetas_app/data/database/database.dart';
import 'package:recetas_app/providers/search_notifier.dart';
import 'receta_list_card.dart';

class RecetaDataView extends StatelessWidget {
  const RecetaDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final searchNotifier = context.watch<SearchNotifier>();
    final theme = Theme.of(context);

    return StreamBuilder<List<Receta>>(
      stream: db.recetasDao.watchAllRecetasFiltered(
        searchNotifier.query,
        searchNotifier.filter,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(theme, searchNotifier.query);
        }

        final recetas = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: recetas.length,
          itemBuilder: (context, index) => RecetaListCard(receta: recetas[index], db: db),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, String query) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 10),
              Text(
                query.isEmpty ? 'No hay recetas aún.' : 'No se encontraron recetas.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              if (query.isEmpty)
                const Text(
                  'Presiona "+" para añadir una nueva receta.',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}