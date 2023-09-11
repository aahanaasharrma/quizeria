import 'package:flutter/material.dart';
import 'quiz_data.dart';

class QuizResultScreen extends StatelessWidget {
  final List<Question> questions;
  final int correctAnswers;

  QuizResultScreen({
    required this.questions,
    required this.correctAnswers,
    int currentScore = 0, // Provide a default value for currentScore
    int totalQuestions = 0, // Provide a default value for totalQuestions
  });

  String getFeedback() {
    // You can customize feedback messages based on the user's performance here
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
            image: AssetImage("assets/images/home_bg.jpg"), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40), // Add space at the top
            TextButton(
              onPressed: () {
                // Use Navigator.popUntil to go back to the home page
                Navigator.popUntil(context, ModalRoute.withName('home_page.dart')); // Replace '/' with the route of your home page
              },

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                getFeedback(), // Display the feedback message
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.brown, // Set text color to brown
                  fontWeight: FontWeight.bold, // Make text bolder
                ),
                textAlign: TextAlign.center, // Center align the text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
