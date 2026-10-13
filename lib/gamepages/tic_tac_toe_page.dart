import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  final VoidCallback onWin;

  const TicTacToePage({super.key, required this.onWin});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String message = "Player X's turn";
  bool finished = false;

  final List<List<int>> winningLines = const [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];

  void _play(int index) {
    if (finished || board[index].isNotEmpty) return;

    setState(() {
      board[index] = currentPlayer;

      final won = winningLines.any(
        (line) => line.every((cell) => board[cell] == currentPlayer),
      );

      if (won) {
        finished = true;
        message = 'Player $currentPlayer wins!';
        widget.onWin();
      } else if (!board.contains('')) {
        finished = true;
        message = "It's a draw!";
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        message = "Player $currentPlayer's turn";
      }
    });
  }

  void _reset() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      message = "Player X's turn";
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic-Tac-Toe')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 24),
                AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => _play(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            board[index],
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: board[index] == 'X'
                                  ? Colors.cyan
                                  : Colors.purpleAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart Game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}