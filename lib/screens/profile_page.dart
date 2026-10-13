import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final int gamesPlayed;
  final int wins;
  final int xp;

  const ProfilePage({
    super.key,
    required this.username,
    required this.gamesPlayed,
    required this.wins,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(
          radius: 42,
          child: Icon(Icons.person, size: 44),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _stat(context, 'Games launched', gamesPlayed, Icons.sports_esports),
        _stat(context, 'Wins', wins, Icons.emoji_events),
        _stat(context, 'Experience points', xp, Icons.bolt),
        const SizedBox(height: 16),
        const Text(
          'Your statistics are tracked during this app session.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _stat(
    BuildContext context,
    String title,
    int value,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.purple),
        title: Text(title),
        trailing: Text(
          '$value',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}