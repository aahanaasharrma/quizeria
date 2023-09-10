import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart'; // Import the html package

class Question {
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  int? userAnswerIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    this.userAnswerIndex,
  });

  bool get isCorrect {
    return userAnswerIndex == correctOptionIndex;
  }
}


Future<List<Question>> fetchQuestions(String? category, int numberOfQuestions) async {
  if (category == null) {
    throw ArgumentError("Category cannot be null.");
  }
  final response = await http.get(
    Uri.parse('https://opentdb.com/api.php?amount=$numberOfQuestions&category=$category'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> questions = data['results'];

    return questions.map((questionData) {
      final questionText = parse(questionData['question']).body?.text; // Decode HTML character entities
      return Question(
        text: questionText ?? "", // Use an empty string if parsing fails
        options: List<String>.from(questionData['incorrect_answers']) + [questionData['correct_answer']],
        correctOptionIndex: questionData['incorrect_answers'].length,
      );
    }).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}
