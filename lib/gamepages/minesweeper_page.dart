import 'dart:math';
import 'package:flutter/material.dart';

class MinesweeperPage extends StatefulWidget {
  const MinesweeperPage({super.key});

  @override
  State<MinesweeperPage> createState() => _MinesweeperPageState();
}

class _MinesweeperPageState extends State<MinesweeperPage> {
  static const int rows = 10;
  static const int cols = 10;
  static const int mineCount = 12;

  final Random random = Random();
  late Set<int> mines;
  late Set<int> revealed;
  late Set<int> flagged;
  bool gameOver = false;
  bool won = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    mines = {};
    while (mines.length < mineCount) {
      mines.add(random.nextInt(rows * cols));
    }
    revealed = {};
    flagged = {};
    gameOver = false;
    won = false;
  }

  int _neighbors(int index) {
    final row = index ~/ cols;
    final col = index % cols;
    int count = 0;

    for (int r = row - 1; r <= row + 1; r++) {
      for (int c = col - 1; c <= col + 1; c++) {
        if (r < 0 || r >= rows || c < 0 || c >= cols) continue;
        if (mines.contains(r * cols + c)) count++;
      }
    }

    return count;
  }

  void _tap(int index) {
    if (gameOver || revealed.contains(index) || flagged.contains(index)) {
      return;
    }

    setState(() {
      revealed.add(index);

      if (mines.contains(index)) {
        gameOver = true;
        won = false;
      } else if (revealed.length >= rows * cols - mineCount) {
        gameOver = true;
        won = true;
      }
    });
  }

  void _flag(int index) {
    if (gameOver || revealed.contains(index)) return;

    setState(() {
      if (!flagged.add(index)) flagged.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minesweeper')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('Tap to reveal a tile. Long-press to flag it.'),
            const SizedBox(height: 8),
            if (gameOver)
              Text(
                won ? 'You cleared the board!' : 'Mine found! Game over.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: rows * cols,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  final isRevealed = revealed.contains(index);
                  final isMine = mines.contains(index);
                  final isFlagged = flagged.contains(index);
                  final count = _neighbors(index);

                  return GestureDetector(
                    onTap: () => _tap(index),
                    onLongPress: () => _flag(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isRevealed
                            ? Colors.white12
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          isRevealed
                              ? (isMine ? '💣' : count == 0 ? '' : '$count')
                              : isFlagged
                                  ? '🚩'
                                  : '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(_reset),
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}