import 'package:flutter/material.dart';
import 'quiz_data.dart';

class QuizResultScreen extends StatelessWidget {
  final List<Question> questions;
  final int correctAnswers;

  QuizResultScreen({
    required this.questions,
    required this.correctAnswers,
    required int currentScore,
    required int totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.jpg"), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40), // Add space at the top
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown), // Set button background color to brown
                minimumSize: MaterialStateProperty.all(Size(400, 80)), // Set button size
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Set button border radius
                  ),
                ),
              ),
              child: Text(
                "Total Score: ${correctAnswers}/${questions.length}",
                style: TextStyle(
                  fontSize: 30, // Increase font size
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final isCorrect = question.userAnswerIndex == question.correctOptionIndex;
                  final isUnanswered = question.userAnswerIndex == -1; // -1 indicates an unanswered question
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
                              fontWeight: FontWeight.bold, // Make text bolder
                              color: textColor, // Set text color to green, blue, or red
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: "${question.text}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make text bolder
                              color: textColor, // Set text color to green, blue, or red
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
                              fontWeight: FontWeight.bold, // Make text bolder
                              color: textColor, // Set text color to green, blue, or red
                              fontSize:20,
                            ),
                          ),
                          TextSpan(
                            text: "${question.userAnswerIndex != null ? question.options[question.userAnswerIndex!] : 'N/A'}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make text bolder
                              color: textColor, // Set text color to green, blue, or red
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: " (Correct Answer: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make text bolder
                              color: textColor,
                              fontSize: 20,// Set text color to green, blue, or red
                            ),
                          ),
                          TextSpan(
                            text: "${question.options[question.correctOptionIndex]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make text bolder
                              color: textColor, // Set text color to green, blue, or red
                              fontSize: 20,
                            ),
                          ),
                          TextSpan(
                            text: ")",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Make text bolder
                              color: textColor, // Set text color to green, blue, or red
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
          ],
        ),
      ),
    );
  }
}
