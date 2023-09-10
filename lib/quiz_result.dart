import 'package:flutter/material.dart';
import 'quiz_data.dart';

class QuizResultScreen extends StatelessWidget {
  final List<Question> questions;
  final int correctAnswers;

  QuizResultScreen({
    required this.questions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Results"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total Score: ${correctAnswers}/${questions.length}",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final isCorrect = question.userAnswerIndex == question.correctOptionIndex;

                return ListTile(
                  title: Text(question.text),
                  subtitle: Text(
                    isCorrect
                        ? "Your Answer: ${question.options[question.userAnswerIndex!]}"
                        : "Your Answer: ${question.options[question.userAnswerIndex!]} (Correct Answer: ${question.options[question.correctOptionIndex]})",
                  ),
                  tileColor: isCorrect ? Colors.green : Colors.red,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
