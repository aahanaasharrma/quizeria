import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  final String text;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });
}

Future<List<Question>> fetchQuestions(String? category, int numberOfQuestions) async {
  if (category == null) {
    throw ArgumentError("Category cannot be null.");
  }
  final response = await http.get(
    Uri.parse('https://opentdb.com/api.php?amount=$numberOfQuestions&category=$category'), // Include the 'category' and 'amount' parameters
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> questions = data['results'];

    return questions.map((questionData) {
      return Question(
        text: questionData['question'],
        options: List<String>.from(questionData['incorrect_answers']) + [questionData['correct_answer']],
        correctOptionIndex: questionData['incorrect_answers'].length,
      );
    }).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}
