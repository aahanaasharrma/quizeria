import 'package:flutter/material.dart';
import 'package:quizeria/quiz_result.dart';
import 'dart:async';
import 'quiz_data.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;
  final int numberOfQuestions;
  final List<Question>? customQuestions;

  QuizScreen({
    required this.categoryId,
    required this.numberOfQuestions,
    this.customQuestions,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int secondsRemaining = 30;
  late Timer timer;
  int currentScore = 0;
  int totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    if (widget.customQuestions == null) {
      totalQuestions = widget.numberOfQuestions;
      fetchQuizQuestions();
      startTimer();
    } else {
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
      print('Error fetching questions: $e');
    }
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (secondsRemaining == 0) {
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
        correctAnswers++;
        currentScore++;
      }
    }

    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        secondsRemaining = 30;
      });
    } else {
      showQuizResults();
    }
  }

  void showQuizResults() {
    timer.cancel();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          questions: questions,
          correctAnswers: correctAnswers,
          currentScore: currentScore,
          totalQuestions: totalQuestions,
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
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey, width: 5.0),
                  right: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Question ${currentQuestionIndex + 1} of $totalQuestions\n\n${currentQuestion.text}",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Time Remaining: $secondsRemaining seconds",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: currentQuestion.options
                        .asMap()
                        .entries
                        .map((entry) => Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          handleAnswerSelection(entry.key);
                        },
                        style: TextButton.styleFrom(primary: Colors.transparent),
                        child: Text(
                          entry.value,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50.0,
              right: 10.0,
              child: Text(
                "Score: $currentScore",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
