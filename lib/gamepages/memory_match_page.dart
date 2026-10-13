import 'dart:math';
import 'package:flutter/material.dart';

class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  final List<String> symbols = [
    '🍎', '🍌', '🍇', '🍒',
    '⭐', '🌙', '🚀', '🎮',
  ];

  late List<String> cards;
  final Set<int> revealed = {};
  final Set<int> matched = {};
  int moves = 0;
  bool checking = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    cards = [...symbols, ...symbols]..shuffle(Random());
    revealed.clear();
    matched.clear();
    moves = 0;
    checking = false;
  }

  Future<void> _tap(int index) async {
    if (checking ||
        revealed.contains(index) ||
        matched.contains(index)) {
      return;
    }

    setState(() {
      revealed.add(index);
    });

    if (revealed.length == 2) {
      moves++;
      final pair = revealed.toList();

      if (cards[pair[0]] == cards[pair[1]]) {
        setState(() {
          matched.addAll(pair);
          revealed.clear();
        });
      } else {
        checking = true;
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        setState(() {
          revealed.clear();
          checking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final complete = matched.length == cards.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Memory Match')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Moves: $moves'),
            if (complete)
              const Text(
                'You matched every pair!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: cards.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final visible =
                      revealed.contains(index) || matched.contains(index);

                  return InkWell(
                    onTap: () => _tap(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: visible
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          visible ? cards[index] : '?',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            FilledButton(
              onPressed: () => setState(_reset),
              child: const Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}