import 'package:flutter/material.dart';
import '../models/game_info.dart';
import '../widgets/game_card.dart';

class DeveloperLabPage extends StatefulWidget {
  final List<GameInfo> offlineGames;
  final List<GameInfo> onlineGames;
  final ValueChanged<GameInfo> onLaunchGame;

  const DeveloperLabPage({
    super.key,
    required this.offlineGames,
    required this.onlineGames,
    required this.onLaunchGame,
  });

  @override
  State<DeveloperLabPage> createState() => _DeveloperLabPageState();
}

class _DeveloperLabPageState extends State<DeveloperLabPage> {
  bool developerMode = false;
  bool aiOpponent = false;
  String difficulty = 'Normal';
  int maxPlayers = 2;
  final TextEditingController _notesController = TextEditingController();
  final List<String> savedPresets = [];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _deletePreset(String preset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete preset?'),
        content: Text('Delete "$preset"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => savedPresets.remove(preset));
    }
  }

  void _savePreset() {
    final name = _notesController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter preset notes first.')),
      );
      return;
    }

    setState(() => savedPresets.add(name));
    _notesController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preset saved for this session.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Developer Mode'),
          subtitle: const Text('Show developer options'),
          value: developerMode,
          onChanged: (value) => setState(() => developerMode = value),
        ),
        SwitchListTile(
          title: const Text('AI Opponent'),
          subtitle: const Text('Preference setting; not connected to game AI'),
          value: aiOpponent,
          onChanged: (value) => setState(() => aiOpponent = value),
        ),
        const Divider(),
        const Text(
          'Game Difficulty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: difficulty,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Easy', child: Text('Easy')),
            DropdownMenuItem(value: 'Normal', child: Text('Normal')),
            DropdownMenuItem(value: 'Hard', child: Text('Hard')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => difficulty = value);
          },
        ),
        const SizedBox(height: 16),
        Text('Maximum Players: $maxPlayers'),
        Slider(
          value: maxPlayers.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: '$maxPlayers',
          onChanged: (value) =>
              setState(() => maxPlayers = value.round()),
        ),
        const Divider(),
        const Text(
          'Save Developer Preset',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLength: 80,
          decoration: const InputDecoration(
            labelText: 'Preset name or notes',
            border: OutlineInputBorder(),
          ),
        ),
        FilledButton.icon(
          onPressed: _savePreset,
          icon: const Icon(Icons.save),
          label: const Text('Save Preset'),
        ),
        if (savedPresets.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Saved Presets',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...savedPresets.map(
            (preset) => ListTile(
              title: Text(preset),
              trailing: IconButton(
                tooltip: 'Delete preset',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deletePreset(preset),
              ),
            ),
          ),
        ],
        const Divider(),
        const Text(
          'Quick Game Launch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...widget.offlineGames.map(
          (game) => GameCard(
            game: game,
            onTap: () => widget.onLaunchGame(game),
          ),
        ),
      ],
    );
  }
}