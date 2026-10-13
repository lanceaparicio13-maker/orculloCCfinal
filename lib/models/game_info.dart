class GameInfo {
  final String title;
  final String description;
  final String category;
  final String emoji;
  final bool isOnline;

  const GameInfo({
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
    this.isOnline = false,
  });
}