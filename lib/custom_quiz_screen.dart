import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizeria/quiz_data.dart';
import 'dart:convert';

import 'package:quizeria/quiz_screen.dart';

class CustomQuizScreen extends StatefulWidget {
  @override
  _CustomQuizScreenState createState() => _CustomQuizScreenState();
}

class _CustomQuizScreenState extends State<CustomQuizScreen> {
  final TextEditingController _topicController = TextEditingController();
  int numberOfQuestions = 10;
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://opentdb.com/api_category.php'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryData = data['trivia_categories'];

      setState(() {
        var categories = categoryData.map((category) {
          return CategoryData(
            id: category['id'],
            name: category['name'],
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchCategoryID(String topic) async {
    final response = await http.get(
      Uri.parse('https://opentdb.com/api_category.php'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categories = data['trivia_categories'];

      final category = categories.firstWhere(
            (category) =>
            category['name'].toLowerCase().contains(topic.toLowerCase()),
        orElse: () => null,
      );

      if (category != null) {
        setState(() {
          selectedCategoryId = category['id'].toString();
        });

        final questions = await fetchQuestionsByCategory(
          selectedCategoryId!,
          numberOfQuestions,
        );

        if (questions.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                categoryId: selectedCategoryId!,
                numberOfQuestions: numberOfQuestions,
                customQuestions: questions,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No questions found for the topic '$topic'."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No category found for the topic '$topic'."),
          ),
        );
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Enter Topic",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
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
                Container(
                  width: 250,
                  child: TextField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      hintText: "Enter the topic",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final topic = _topicController.text;
                      if (topic.isNotEmpty) {
                        final categoryId = await fetchCategoryIDByTopic(topic);

                        if (categoryId != null) {
                          final questions = await fetchQuestionsByCategory(
                              categoryId, numberOfQuestions);

                          if (questions.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  categoryId: categoryId,
                                  numberOfQuestions: numberOfQuestions,
                                  customQuestions: questions,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No questions found for the topic '$topic'."),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("No category found for the topic '$topic'."),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter a topic for your custom quiz."),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Start Custom Quiz",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryData {
  final int id;
  final String name;

  CategoryData({
    required this.id,
    required this.name,
  });
}
