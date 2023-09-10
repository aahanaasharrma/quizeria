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

Future<List<Question>> fetchQuestionsByTopic(String topic, int numberOfQuestions) async {
  if (topic.isEmpty) {
    throw ArgumentError("Topic cannot be empty.");
  }

  final formattedTopic = Uri.encodeComponent(topic); // Encode the topic for URL
  final apiUrl = 'https://opentdb.com/api.php?amount=$numberOfQuestions&category=custom&topic=$formattedTopic';
  print('API URL: $apiUrl'); // Add this line for debugging

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> questions = data['results'];

    return questions.map((questionData) {
      final List<String> options = questionData['incorrect_answers'].cast<String>();
      options.add(questionData['correct_answer']);

      return Question(
        text: questionData['question'],
        options: options,
        correctOptionIndex: options.indexOf(questionData['correct_answer']),
      );
    }).toList();
  } else {
    print('API Request Failed: ${response.statusCode}'); // Add this line for debugging
    throw Exception('Failed to load questions');
  }
}