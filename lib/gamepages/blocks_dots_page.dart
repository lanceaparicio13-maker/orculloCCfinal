import 'package:flutter/material.dart';

class BlocksDotsPage extends StatefulWidget {
  const BlocksDotsPage({super.key});

  @override
  State<BlocksDotsPage> createState() => _BlocksDotsPageState();
}

class _BlocksDotsPageState extends State<BlocksDotsPage> {
  final Set<String> edges = {};
  final List<int> owners = List.filled(9, 0);
  int player = 1;

  String _edge(int a, int b) => a < b ? '$a-$b' : '$b-$a';

  void _tapEdge(int a, int b) {
    final key = _edge(a, b);
    if (edges.contains(key)) return;

    setState(() {
      edges.add(key);

      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          final cell = row * 3 + col;
          if (owners[cell] != 0) continue;

          final top = _edge(row * 4 + col, row * 4 + col + 1);
          final bottom = _edge((row + 1) * 4 + col,
              (row + 1) * 4 + col + 1);
          final left = _edge(row * 4 + col, (row + 1) * 4 + col);
          final right =
              _edge(row * 4 + col + 1, (row + 1) * 4 + col + 1);

          if ([top, bottom, left, right].every(edges.contains)) {
            owners[cell] = player;
          }
        }
      }

      player = player == 1 ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blocks & Dots')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Player $player — tap an edge to draw a line.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1,
            child: Column(
              children: List.generate(4, (row) {
                return Expanded(
                  child: Row(
                    children: List.generate(7, (column) {
                      if (column.isEven) {
                        return Expanded(
                          child: Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }

                      final col = column ~/ 2;
                      final a = row * 4 + col;
                      final b = a + 1;
                      final active = edges.contains(_edge(a, b));

                      return Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => _tapEdge(a, b),
                          child: Container(
                            height: 8,
                            color: active
                                ? (player == 1
                                    ? Colors.cyan
                                    : Colors.purpleAccent)
                                : Colors.white24,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => setState(() {
              edges.clear();
              owners.fillRange(0, owners.length, 0);
              player = 1;
            }),
            child: const Text('Reset Board'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Two-player practice board. Complete all four sides of a square to claim it.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}