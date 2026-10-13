import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'https://opentdb.com/api.php?amount=10&type=multiple';

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http
        .get(Uri.parse(_baseUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Unable to load questions. Please try again.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['response_code'] != 0) {
      throw Exception('No questions available. Please try again.');
    }

    return List<Map<String, dynamic>>.from(data['results']);
  }
}