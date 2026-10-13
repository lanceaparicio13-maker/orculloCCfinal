import 'dart:math';
import 'package:flutter/material.dart';

class SnakesLaddersPage extends StatefulWidget {
  const SnakesLaddersPage({super.key});

  @override
  State<SnakesLaddersPage> createState() => _SnakesLaddersPageState();
}

class _SnakesLaddersPageState extends State<SnakesLaddersPage> {
  final Random random = Random();
  int position = 0;
  int dice = 1;
  bool finished = false;

  final Map<int, int> jumps = {
    4: 14, 9: 31, 20: 38, 28: 84,
    40: 59, 51: 67, 63: 81, 17: 7,
    54: 34, 62: 19, 87: 24, 95: 75,
  };

  void _roll() {
    if (finished) return;

    setState(() {
      dice = random.nextInt(6) + 1;

      if (position + dice <= 100) {
        position += dice;
        position = jumps[position] ?? position;
      }

      if (position == 100) finished = true;
    });
  }

  void _reset() {
    setState(() {
      position = 0;
      dice = 1;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snakes & Ladders')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                finished ? 'You reached 100! You win!' : 'Position: $position',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('🎲 $dice', style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 20),
              Text(
                'Next roll: ${position + dice <= 100 ? position + dice : "Too high"}',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: finished ? null : _roll,
                child: const Text('Roll Dice'),
              ),
              TextButton(
                onPressed: _reset,
                child: const Text('Restart'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Reach exactly square 100. Ladders move you forward; snakes move you backward.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}