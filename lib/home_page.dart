import 'package:flutter/material.dart';
import 'quiz_data.dart';
import 'quiz_screen.dart';

class HomePage extends StatelessWidget {
  final Map<String, String> categoryIds = {
    "Science": "17", // Replace with actual category IDs for your categories
    "General Knowledge": "9",
    "History": "23",
    "Geography": "22",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Categories"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: categoryIds.keys.map((categoryName) {
            final categoryId = categoryIds[categoryName];
            return ElevatedButton(
              onPressed: () async {
                final categoryId = categoryIds[categoryName];
                if (categoryId != null) {
                  final questions = await fetchQuestions(categoryId, 10); // Pass the category ID
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        categoryId: categoryId,
                        numberOfQuestions: 10, // Specify the number of questions you want
                      ),
                    ),
                  );
                } else {
                  // Handle the case where categoryId is null
                  // You can show an error message or take appropriate action.
                }
              },
              child: Text("Start $categoryName Quiz"),
            );
          }).toList(),
        ),
      ),
    );
  }
}
