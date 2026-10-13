import 'package:flutter/material.dart';

class ChessPage extends StatefulWidget {
  const ChessPage({super.key});

  @override
  State<ChessPage> createState() => _ChessPageState();
}

class _ChessPageState extends State<ChessPage> {
  late List<String> board;
  int? selected;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    board = List.filled(64, '');
    const back = ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜'];

    for (int col = 0; col < 8; col++) {
      board[col] = back[col];
      board[8 + col] = '♟';
      board[48 + col] = '♙';
      board[56 + col] =
          ['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖'][col];
    }

    selected = null;
  }

  void _tap(int index) {
    setState(() {
      if (selected == null) {
        if (board[index].isNotEmpty) selected = index;
      } else {
        if (selected != index) {
          board[index] = board[selected!];
          board[selected!] = '';
        }
        selected = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chess Board Demo')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Tap a piece, then tap its destination. Legal chess moves are not enforced.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 64,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                final row = index ~/ 8;
                final col = index % 8;
                final dark = (row + col).isOdd;

                return GestureDetector(
                  onTap: () => _tap(index),
                  child: Container(
                    color: selected == index
                        ? Colors.amber
                        : dark
                            ? const Color(0xFF79634E)
                            : const Color(0xFFE9D8B8),
                    child: Center(
                      child: Text(
                        board[index],
                        style: const TextStyle(
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => setState(_reset),
            child: const Text('Reset Board'),
          ),
        ],
      ),
    );
  }
}