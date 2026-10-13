import 'package:flutter/material.dart';

class SudokuPage extends StatefulWidget {
  const SudokuPage({super.key});

  @override
  State<SudokuPage> createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> {
  static const puzzle = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  late List<List<int>> board;
  late List<List<bool>> fixed;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    board = puzzle.map((row) => List<int>.from(row)).toList();
    fixed = puzzle
        .map((row) => row.map((value) => value != 0).toList())
        .toList();
  }

  Future<void> _editCell(int row, int col) async {
    if (fixed[row][col]) return;

    final controller = TextEditingController(
      text: board[row][col] == 0 ? '' : '${board[row][col]}',
    );

    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Row ${row + 1}, Column ${col + 1}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: const InputDecoration(
            hintText: 'Enter 1–9, or leave blank',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 0),
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text);
              Navigator.pop(
                context,
                parsed != null && parsed >= 1 && parsed <= 9 ? parsed : 0,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (value != null && mounted) {
      setState(() => board[row][col] = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sudoku')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Fill the grid with numbers 1–9. Tap an empty cell to edit it.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 81,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              itemBuilder: (context, index) {
                final row = index ~/ 9;
                final col = index % 9;
                final shade = ((row ~/ 3) + (col ~/ 3)).isEven;

                return GestureDetector(
                  onTap: () => _editCell(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: shade
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 0.4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col] == 0 ? '' : '${board[row][col]}',
                        style: TextStyle(
                          fontWeight: fixed[row][col]
                              ? FontWeight.bold
                              : FontWeight.normal,
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
            child: const Text('Reset Puzzle'),
          ),
        ],
      ),
    );
  }
}