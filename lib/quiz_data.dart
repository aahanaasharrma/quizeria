import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:quizeria/quiz_screen.dart'; // Import the html package

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


Future<List<Question>> fetchQuestions(String category, int numberOfQuestions) async {
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

Future<List<Question>> fetchQuestionsByCategory(String categoryId, int numberOfQuestions) async {
  if (categoryId.isEmpty) {
    throw ArgumentError("Category ID cannot be empty.");
  }

  final apiUrl = 'https://opentdb.com/api.php?amount=$numberOfQuestions&category=$categoryId';
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

Future<String?> fetchCategoryIDByTopic(String topic) async {
  final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> categories = data['trivia_categories'];

    final category = categories.firstWhere(
          (category) => category['name'].toLowerCase() == topic.toLowerCase(),
      orElse: () => null, // Return null if no matching category is found
    );

    if (category != null) {
      return category['id'].toString();
    }
  }

  return null; // Return null if no category is found for the entered topic
}
