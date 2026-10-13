import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/game_info.dart';
import '../widgets/game_card.dart';

import 'profile_page.dart';
import 'game_library_page.dart';
import 'developer_lab_page.dart';
import 'arena_page.dart';

import '../gamepages/blocks_dots_page.dart';
import '../gamepages/snakes_ladders_page.dart';
import '../gamepages/chess_page.dart';
import '../gamepages/sudoku_page.dart';
import '../gamepages/snake_page.dart';
import '../gamepages/tic_tac_toe_page.dart';
import '../gamepages/memory_match_page.dart';
import '../gamepages/minesweeper_page.dart';

class MainPage extends StatefulWidget {
  final String username;

  const MainPage({
    super.key,
    required this.username,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int gamesPlayed = 0;
  int wins = 0;
  int xp = 0;

  final Set<String> favorites = {};

  static const List<GameInfo> offlineGames = [
    GameInfo(
      title: 'Blocks & Dots',
      description: 'Connect edges and complete squares.',
      category: 'Puzzle',
      emoji: '🔷',
    ),
    GameInfo(
      title: 'Snakes & Ladders',
      description: 'Roll the dice and reach the finish.',
      category: 'Board',
      emoji: '🎲',
    ),
    GameInfo(
      title: 'Chess',
      description: 'Play a classic strategy board game.',
      category: 'Strategy',
      emoji: '♟️',
    ),
    GameInfo(
      title: 'Sudoku',
      description: 'Complete the number puzzle.',
      category: 'Puzzle',
      emoji: '🔢',
    ),
    GameInfo(
      title: 'Snake',
      description: 'Collect food and grow longer.',
      category: 'Arcade',
      emoji: '🐍',
    ),
    GameInfo(
      title: 'Tic-Tac-Toe',
      description: 'Get three marks in a row.',
      category: 'Classic',
      emoji: '❎',
    ),
    GameInfo(
      title: 'Memory Match',
      description: 'Find all matching pairs.',
      category: 'Memory',
      emoji: '🧠',
    ),
    GameInfo(
      title: 'Minesweeper',
      description: 'Reveal safe tiles and avoid mines.',
      category: 'Puzzle',
      emoji: '💣',
    ),
  ];

  static const List<GameInfo> onlineGames = [
    GameInfo(
      title: 'Checkers Online',
      description: 'Online multiplayer preview.',
      category: 'Online',
      emoji: '🔴',
      isOnline: true,
    ),
    GameInfo(
      title: 'Connect Four Online',
      description: 'Online multiplayer preview.',
      category: 'Online',
      emoji: '🟡',
      isOnline: true,
    ),
    GameInfo(
      title: 'Reversi Online',
      description: 'Online multiplayer preview.',
      category: 'Online',
      emoji: '⚫',
      isOnline: true,
    ),
  ];

  void _launchGame(GameInfo game) {
    if (game.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Online multiplayer is a preview and needs a game server.',
          ),
        ),
      );
      return;
    }

    final Widget page;

    switch (game.title) {
      case 'Blocks & Dots':
        page = const BlocksDotsPage();
        break;
      case 'Snakes & Ladders':
        page = const SnakesLaddersPage();
        break;
      case 'Chess':
        page = const ChessPage();
        break;
      case 'Sudoku':
        page = const SudokuPage();
        break;
      case 'Snake':
        page = const SnakePage();
        break;
      case 'Tic-Tac-Toe':
        page = TicTacToePage(
          onWin: () {
            if (!mounted) return;
            setState(() {
              wins++;
              xp += 20;
            });
          },
        );
        break;
      case 'Memory Match':
        page = const MemoryMatchPage();
        break;
      case 'Minesweeper':
        page = const MinesweeperPage();
        break;
      default:
        return;
    }

    setState(() {
      gamesPlayed++;
      xp += 5;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _toggleFavorite(GameInfo game) {
    setState(() {
      if (!favorites.add(game.title)) {
        favorites.remove(game.title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      GameLibraryPage(
        games: offlineGames,
        favorites: favorites,
        onGameTap: _launchGame,
        onFavorite: _toggleFavorite,
      ),
      ProfilePage(
        username: widget.username,
        gamesPlayed: gamesPlayed,
        wins: wins,
        xp: xp,
      ),
      DeveloperLabPage(
        onlineGames: onlineGames,
        offlineGames: offlineGames,
        onLaunchGame: _launchGame,
      ),
      const ArenaPage(),
    ];

    const titles = [
      'NEXORA PLAY',
      'Game Library',
      'Player Profile',
      'Developer Lab',
      'Arena',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.code),
            label: 'Developer',
          ),
          NavigationDestination(
            icon: Icon(Icons.public),
            label: 'Arena',
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Welcome, ${widget.username}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose a game and start playing.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _statCard('Games', '$gamesPlayed')),
            const SizedBox(width: 8),
            Expanded(child: _statCard('Wins', '$wins')),
            const SizedBox(width: 8),
            Expanded(child: _statCard('XP', '$xp')),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Offline Games',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...offlineGames.take(4).map(
          (game) => GameCard(
            game: game,
            onTap: () => _launchGame(game),
            isFavorite: favorites.contains(game.title),
            onFavorite: () => _toggleFavorite(game),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => setState(() => _selectedIndex = 1),
          icon: const Icon(Icons.grid_view),
          label: const Text('View All Games'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Online Game Previews',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...onlineGames.map(
          (game) => GameCard(
            game: game,
            onTap: () => _launchGame(game),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.cyan,
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}