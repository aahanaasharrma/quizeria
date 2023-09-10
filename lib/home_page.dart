import 'package:flutter/material.dart';
import 'category_data.dart';
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
                final questions = await fetchQuestions(categoryId!); // Pass the category ID
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      questions: questions,
                      category: Category(
                        name: categoryName,
                        icon: Icons.category, // Replace with the appropriate icon
                        color: Colors.blue, // Replace with the appropriate color
                      ),
                    ),
                  ),
                );
              },
              child: Text("Start $categoryName Quiz"),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the quiz screen for the selected category
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              questions: [], // Pass the questions here (you can fetch them as needed)
              category: category, categoryId: '', // Pass the category here
            ),
          ),
        );
      },
      child: Card(
        color: category.color,
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              category.icon,
              size: 64.0,
              color: Colors.white,
            ),
            SizedBox(height: 10.0),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
