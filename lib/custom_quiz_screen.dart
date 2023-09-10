import 'package:flutter/material.dart';
import 'package:quizeria/quiz_screen.dart';
import 'quiz_data.dart'; // Import your quiz data functions

class CustomQuizScreen extends StatefulWidget {
  @override
  _CustomQuizScreenState createState() => _CustomQuizScreenState();
}

class _CustomQuizScreenState extends State<CustomQuizScreen> {
  final TextEditingController _topicController = TextEditingController();
  int numberOfQuestions = 10; // You can set the default number of questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Custom Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Topic:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                hintText: "Enter the topic for your custom quiz",
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Number of Questions:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: numberOfQuestions,
              onChanged: (value) {
                setState(() {
                  numberOfQuestions = value!;
                });
              },
              items: [5, 10, 15, 20].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final topic = _topicController.text;
                if (topic.isNotEmpty) {
                  // Fetch custom quiz questions based on the topic
                  final questions = await fetchQuestionsByTopic(topic, numberOfQuestions);

                  if (questions.isNotEmpty) {
                    // Navigate to the custom quiz screen with the fetched questions
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          categoryId: "custom", // You can use a special category ID for custom quizzes
                          numberOfQuestions: numberOfQuestions,
                          customQuestions: questions,
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where no questions were found for the given topic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("No questions found for the topic '$topic'."),
                      ),
                    );
                  }
                } else {
                  // Handle the case where the topic field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter a topic for your custom quiz."),
                    ),
                  );
                }
              },
              child: Text("Start Custom Quiz"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }
}
