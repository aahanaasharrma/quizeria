import 'package:flutter/material.dart';
import 'quiz_data.dart';
import 'quiz_screen.dart';
import 'custom_quiz_screen.dart'; // Import the custom quiz screen

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
                image: AssetImage("assets/images/home_bg.jpg"), // Replace with your image asset path
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Choose a Quiz Category:",
                style: TextStyle(
                  fontSize: 24, // Increase font size
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 400, // Set the width of the rectangle
                  height: 400, // Set the height of the rectangle
                  decoration: BoxDecoration(
                    color: Colors.brown, // Set the background color to dark brown
                    borderRadius: BorderRadius.circular(20), // Add rounded corners to the rectangle
                  ),
                  child: GridView.count(
                    crossAxisCount: 2, // 2 columns in each row
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
                            // You can show an error message or take appropriate action.
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0), // Add border to each category
                          ),
                          child: Center(
                            child: Text(
                              categoryName,
                              style: TextStyle(
                                fontSize: categoryName == "Science" || categoryName == "History" || categoryName == "Geography" || categoryName == "General Knowledge"
                                    ? 20  // Increase font size for specific categories
                                    : 18, // Default font size
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the custom quiz creation screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CustomQuizScreen(), // Create and navigate to the custom quiz screen
                    ),
                  );
                },
                child: Text(
                  "Create Custom Quiz",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
