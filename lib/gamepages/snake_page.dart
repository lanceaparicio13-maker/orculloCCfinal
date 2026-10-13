import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class SnakePage extends StatefulWidget {
  const SnakePage({super.key});

  @override
  State<SnakePage> createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  final Random random = Random();
  final int size = 12;

  List<Point<int>> snake = [];
  Point<int> food = const Point(5, 5);
  Direction direction = Direction.right;
  Timer? timer;
  bool playing = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _reset() {
    timer?.cancel();
    setState(() {
      snake = [const Point(4, 6), const Point(3, 6), const Point(2, 6)];
      food = _newFood();
      direction = Direction.right;
      score = 0;
      playing = false;
    });
  }

  Point<int> _newFood() {
    Point<int> next;
    do {
      next = Point(random.nextInt(size), random.nextInt(size));
    } while (snake.contains(next));
    return next;
  }

  void _start() {
    if (playing) return;

    setState(() => playing = true);
    timer = Timer.periodic(
      const Duration(milliseconds: 350),
      (_) => _move(),
    );
  }

  void _move() {
    if (!mounted || !playing) return;

    final head = snake.first;
    Point<int> next;

    switch (direction) {
  case Direction.up:
    next = Point(head.x, head.y - 1);
    break;
  case Direction.down:
    next = Point(head.x, head.y + 1);
    break;
  case Direction.left:
    next = Point(head.x - 1, head.y);
    break;
  case Direction.right:
    next = Point(head.x + 1, head.y);
    break;
}

    final eating = next == food;
    final body = eating ? snake : snake.take(snake.length - 1).toList();

    if (next.x < 0 ||
        next.y < 0 ||
        next.x >= size ||
        next.y >= size ||
        body.contains(next)) {
      timer?.cancel();
      setState(() => playing = false);
      return;
    }

    setState(() {
      snake = [next, ...snake];
      if (eating) {
        score++;
        food = _newFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _changeDirection(Direction next) {
    final opposite = {
      Direction.up: Direction.down,
      Direction.down: Direction.up,
      Direction.left: Direction.right,
      Direction.right: Direction.left,
    };

    if (opposite[direction] == next) return;
    setState(() => direction = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snake')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Score: $score',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: size * size,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 12,
              ),
              itemBuilder: (context, index) {
                final point = Point(index % size, index ~/ size);
                final isHead = snake.isNotEmpty && point == snake.first;
                final isBody = snake.contains(point);
                final isFood = point == food;

                return Container(
                  margin: const EdgeInsets.all(1),
                  color: isHead
                      ? Colors.cyan
                      : isBody
                          ? Colors.purple
                          : isFood
                              ? Colors.redAccent
                              : Colors.white10,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              IconButton(
                onPressed: () => _changeDirection(Direction.up),
                icon: const Icon(Icons.keyboard_arrow_up),
              ),
              IconButton(
                onPressed: () => _changeDirection(Direction.left),
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              IconButton(
                onPressed: () => _changeDirection(Direction.down),
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
              IconButton(
                onPressed: () => _changeDirection(Direction.right),
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          FilledButton(
            onPressed: playing ? null : _start,
            child: const Text('Start / Resume'),
          ),
          TextButton(
            onPressed: _reset,
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}