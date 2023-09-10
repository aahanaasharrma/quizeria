import 'package:flutter/material.dart';
import 'package:quizeria/quiz_result.dart'; // Import the QuizResultScreen
import 'dart:async';
import 'quiz_data.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId; // Pass the category ID
  final int numberOfQuestions; // Specify the number of questions you want

  QuizScreen({
    required this.categoryId,
    required this.numberOfQuestions,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0; // Track the number of correct answers
  int secondsRemaining = 30; // Initial timer value
  late Timer timer; // Timer variable

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
    startTimer();
  }

  void fetchQuizQuestions() async {
    try {
      final fetchedQuestions = await fetchQuestions(
        widget.categoryId, // Pass the category ID
        widget.numberOfQuestions, // Pass the number of questions
      );
      setState(() {
        questions = fetchedQuestions;
      });
    } catch (e) {
      // Handle the error
      print('Error fetching questions: $e');
    }
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (secondsRemaining == 0) {
        // Handle time-up scenario (e.g., move to the next question)
        moveToNextQuestion(didExceedTimer: true);
        return;
      }
      setState(() {
        secondsRemaining--;
      });
    });
  }

  void moveToNextQuestion({bool didExceedTimer = false}) {
    if (!didExceedTimer) {
      if (questions[currentQuestionIndex].isCorrect) {
        // If the user's answer is correct
        correctAnswers++;
      }
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        secondsRemaining = 30; // Reset the timer for the next question
      });
    } else {
      // Handle end of the quiz (e.g., show results)
      showQuizResults();
    }
  }

  void showQuizResults() {
    // Cancel the timer before navigating to the results screen
    timer.cancel();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          questions: questions,
          correctAnswers: correctAnswers,
        ),
      ),
    );
  }

  void handleAnswerSelection(int selectedOptionIndex) {
    final Question currentQuestion = questions[currentQuestionIndex];
    currentQuestion.userAnswerIndex = selectedOptionIndex;
    moveToNextQuestion();
  }

  @override
  void dispose() {
    // Cancel the timer when disposing of the screen
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      // Display a loading indicator or message while fetching questions
      return Center(child: CircularProgressIndicator());
    }

    final Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentQuestion.text,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // Display timer
            Text(
              "Time Remaining: $secondsRemaining seconds",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Display answer options as buttons (you can customize the UI)
            Column(
              children: currentQuestion.options
                  .asMap()
                  .entries
                  .map((entry) => ElevatedButton(
                onPressed: () {
                  // Handle option selection
                  handleAnswerSelection(entry.key);
                },
                child: Text(entry.value),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
