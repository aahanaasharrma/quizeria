import 'package:flutter/material.dart';
import 'package:quizeria/quiz_result.dart'; // Import the QuizResultScreen
import 'dart:async';
import 'quiz_data.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId; // Pass the category ID
  final int numberOfQuestions; // Specify the number of questions you want
  final List<Question>? customQuestions; // Add a parameter for custom questions

  QuizScreen({
    required this.categoryId,
    required this.numberOfQuestions,
    this.customQuestions, // Initialize the parameter
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
  int currentScore = 0; // Variable to keep track of the current score
  int totalQuestions = 0; // Variable to store the total number of questions

  @override
  void initState() {
    super.initState();
    if (widget.customQuestions == null) {
      // Fetch questions only if custom questions are not provided
      totalQuestions = widget.numberOfQuestions;
      fetchQuizQuestions();
      startTimer();
    } else {
      // Use custom questions if provided
      questions = widget.customQuestions!;
      totalQuestions = questions.length;
      startTimer();
    }
  }

  void fetchQuizQuestions() async {
    try {
      final fetchedQuestions = await fetchQuestions(widget.categoryId, widget.numberOfQuestions);
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
        currentScore++; // Increase the score
      }
    }

    if (currentQuestionIndex < totalQuestions - 1) {
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
          currentScore: currentScore, // Pass the current score
          totalQuestions: totalQuestions, // Pass the total number of questions
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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey, width: 5.0), // Increase left border width
                right: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Question ${currentQuestionIndex + 1} of $totalQuestions", // Display question number
                    style: TextStyle(fontSize: 18),
                  ),
                ),
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
          Positioned(
            top: 50.0, // Adjust the top position as needed to bring it down
            right: 10.0, // Adjust the right position as needed
            child: Text(
              "Score: $currentScore", // Display current score
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
