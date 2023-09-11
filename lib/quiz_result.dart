import 'package:flutter/material.dart';
import 'quiz_data.dart';

class QuizResultScreen extends StatelessWidget {
  final List<Question> questions;
  final int correctAnswers;

  QuizResultScreen({
    required this.questions,
    required this.correctAnswers,
    int currentScore = 0,
    int totalQuestions = 0,
  });

  String getFeedback() {
    if (correctAnswers == questions.length) {
      return "Perfect Score! You answered all questions correctly!";
    } else if (correctAnswers >= questions.length / 2) {
      return "Good Job! You got $correctAnswers out of ${questions.length} correct.";
    } else {
      return "Keep Practicing. You got $correctAnswers out of ${questions.length} correct.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('home_page.dart'));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
                minimumSize: MaterialStateProperty.all(Size(400, 80)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: Text(
                "Total Score: ${correctAnswers}/${questions.length}",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final isCorrect = question.userAnswerIndex == question.correctOptionIndex;
                  final isUnanswered = question.userAnswerIndex == -1;
                  final textColor = isCorrect ? Colors.green : (isUnanswered ? Colors.blue : Colors.red);
                  final yourAnswerText = isUnanswered ? "Your Answer: Not Answered" : "Your Answer: ${question.userAnswerIndex != null ? question.options[question.userAnswerIndex!] : 'N/A'}";

                  return ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: "Question ${index + 1}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: "${question.text}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: isUnanswered ? "Your Answer: Not Answered" : "Your Answer: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize:20,
                            ),
                          ),
                          TextSpan(
                            text: "${question.userAnswerIndex != null ? question.options[question.userAnswerIndex!] : 'N/A'}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: " (Correct Answer: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: "${question.options[question.correctOptionIndex]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: ")",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                getFeedback(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
