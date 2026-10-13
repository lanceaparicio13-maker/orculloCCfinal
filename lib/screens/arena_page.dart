import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ArenaPage extends StatefulWidget {
  const ArenaPage({super.key});

  @override
  State<ArenaPage> createState() => _ArenaPageState();
}

class _ArenaPageState extends State<ArenaPage> {
  final ApiService _api = ApiService();
  late Future<List<Map<String, dynamic>>> _questions;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    _questions = _api.fetchQuestions();
  }

  void _retry() {
    setState(_loadQuestions);
  }

  String _decodeHtml(String value) {
    return value
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _questions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 48),
                  const SizedBox(height: 12),
                  const Text('Could not load questions.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _retry,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final questions = snapshot.data ?? [];

        if (questions.isEmpty) {
          return Center(
            child: FilledButton(
              onPressed: _retry,
              child: const Text('Reload Questions'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: questions.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Trivia Arena',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final question = questions[index - 1];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question $index',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _decodeHtml(
                        question['question']?.toString() ?? '',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Category: ${_decodeHtml(question['category']?.toString() ?? 'General')}',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}