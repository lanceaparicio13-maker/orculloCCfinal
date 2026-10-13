import 'package:flutter/material.dart';
import '../models/game_info.dart';
import '../widgets/game_card.dart';

class GameLibraryPage extends StatefulWidget {
  final List<GameInfo> games;
  final Set<String> favorites;
  final ValueChanged<GameInfo> onGameTap;
  final ValueChanged<GameInfo> onFavorite;

  const GameLibraryPage({
    super.key,
    required this.games,
    required this.favorites,
    required this.onGameTap,
    required this.onFavorite,
  });

  @override
  State<GameLibraryPage> createState() => _GameLibraryPageState();
}

class _GameLibraryPageState extends State<GameLibraryPage> {
  String query = '';
  bool favoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.games.where((game) {
      final matchesSearch =
          game.title.toLowerCase().contains(query.toLowerCase());
      final matchesFavorite =
          !favoritesOnly || widget.favorites.contains(game.title);
      return matchesSearch && matchesFavorite;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  labelText: 'Search games',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Favorites only'),
                value: favoritesOnly,
                onChanged: (value) =>
                    setState(() => favoritesOnly = value),
              ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text('No games found. Try another search.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final game = filtered[index];
                    final isFavorite =
                        widget.favorites.contains(game.title);

                    return GameCard(
                      game: game,
                      isFavorite: isFavorite,
                      onTap: () => widget.onGameTap(game),
                      onFavorite: () async {
                        if (isFavorite) {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Remove favorite?'),
                              content: Text(
                                'Remove ${game.title} from favorites?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed != true || !mounted) return;
                        }

                        widget.onFavorite(game);
                        setState(() {});
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}