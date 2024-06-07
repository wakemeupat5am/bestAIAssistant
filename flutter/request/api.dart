import 'dart:convert';
import 'package:http/http.dart' as http;

class MyAPI {
  static const String baseURL = '';

  static Future<List<String>> searchArticles(String theme) async {
    final response = await http.post(
      Uri.parse('$baseURL/search'),
      body: jsonEncode({'theme': theme}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['articles'];
      return data.map((item) => item.toString()).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  static Future<String> askQuestion(String theme, String question) async {
    final response = await http.post(
      Uri.parse('$baseURL/question'),
      body: jsonEncode({'theme': theme, 'question': question}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['answer'];
    } else {
      throw Exception('Failed to get answer');
    }
  }
}


// Для поиска статей по тематике
Future<void> searchArticles() async {
  try {
    List<String> articles = await MyAPI.searchArticles('тематика запроса');
    // Обработка полученных статей
  } catch (e) {
    // Обработка ошибки
  }
}

// Для отправки вопроса по выбранной теме
Future<void> askQuestion() async {
  try {
    String answer = await MyAPI.askQuestion('тематика запроса', 'текст вопроса');
    // Обработка полученного ответа
  } catch (e) {
    // Обработка ошибки
  }
}