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
      body: Container(
        color: Colors.black, // Set the background color to black
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Total Score: ${correctAnswers}/${questions.length}",
                  style: TextStyle(
                    fontSize: 30, // Increase font size
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final isCorrect = question.userAnswerIndex == question.correctOptionIndex;
                  final textColor = isCorrect ? Colors.green : Colors.red;

                  return ListTile(
                    title: Text(
                      "Question ${index + 1}: ${question.text}",
                      style: TextStyle(
                        color: textColor, // Set text color to green or red
                      ),
                    ),
                    subtitle: Text(
                      isCorrect
                          ? "Your Answer: ${question.options[question.userAnswerIndex!]} (Correct Answer: ${question.options[question.correctOptionIndex]})"
                          : "Your Answer: ${question.options[question.userAnswerIndex!]} (Correct Answer: ${question.options[question.correctOptionIndex]})",
                      style: TextStyle(
                        color: textColor, // Set text color to green or red
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
