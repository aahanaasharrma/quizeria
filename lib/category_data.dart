import 'package:flutter/material.dart';
import 'quiz_data.dart'; // Import the Quiz class from quiz_data.dart

class Category {
  final String name;
  final IconData icon;
  final Color color;
  final Quiz quiz; // Add the quiz property

  Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.quiz, // Initialize the quiz property in the constructor
  });
}

final List<Category> categories = [
  Category(
    name: "General Knowledge",
    icon: Icons.book,
    color: Colors.blue,
    quiz: Quiz(
      questions: [
        Question(
          text: "What is the capital of France?",
          options: ["London", "Berlin", "Paris", "Madrid"],
          correctOptionIndex: 2,
        ),
        // Add more questions for General Knowledge
      ],
    ),
  ),
  Category(
    name: "Science",
    icon: Icons.science,
    color: Colors.green,
    quiz: Quiz(
      questions: [
        Question(
          text: "What is the chemical symbol for water?",
          options: ["H2O", "CO2", "O2", "N2"],
          correctOptionIndex: 0,
        ),
        // Add more questions for Science
      ],
    ),
  ),
  // Add similar data for other categories
];
