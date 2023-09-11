import 'package:flutter/material.dart';
import 'quiz_data.dart';
import 'quiz_screen.dart';
import 'custom_quiz_screen.dart';

class HomePage extends StatelessWidget {
  final Map<String, String> categoryIds = {
    "Science": "17",
    "General Knowledge": "9",
    "History": "23",
    "Geography": "22",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Choose a Quiz Category:",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: categoryIds.keys.map((categoryName) {
                      final categoryId = categoryIds[categoryName];
                      return GestureDetector(
                        onTap: () async {
                          final categoryId = categoryIds[categoryName];
                          if (categoryId != null) {
                            final questions = await fetchQuestions(categoryId, 10);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  categoryId: categoryId,
                                  numberOfQuestions: 15,
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where categoryId is null
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0),
                          ),
                          child: Center(
                            child: Text(
                              categoryName,
                              style: TextStyle(
                                fontSize: categoryName == "Science" || categoryName == "History" || categoryName == "Geography" || categoryName == "General Knowledge"
                                    ? 20
                                    : 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Create your own custom quiz:",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CustomQuizScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 400,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Create Custom Quiz",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
