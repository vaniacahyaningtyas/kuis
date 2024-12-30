import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Quiz(),
      child: MaterialApp(
        home: QuizPage(),
      ),
    );
  }
}

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var quiz = Provider.of<Quiz>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: quiz.isQuizFinished
          ? Center(
              child: Text('Your score: ${quiz.totalScore}'),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    quiz.questions[quiz.questionIndex]['questionText'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        quiz.questions[quiz.questionIndex]['answers'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () => quiz.answerQuestion(
                              quiz.questions[quiz.questionIndex]['answers']
                                  [index]['score']),
                          child: Text(
                            quiz.questions[quiz.questionIndex]['answers'][index]
                                ['text'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: quiz.resetQuiz,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Quiz with ChangeNotifier {
  final List<Map<String, dynamic>> _questions = [
    {
      'questionText': 'What is Flutter?',
      'answers': [
        {'text': 'A programming language', 'score': 0},
        {'text': 'A web framework', 'score': 0},
        {'text': 'A mobile UI framework', 'score': 1},
        {'text': 'A game', 'score': 0},
      ],
    },
    {
      'questionText': 'What language is Flutter written in?',
      'answers': [
        {'text': 'Dart', 'score': 1},
        {'text': 'Java', 'score': 0},
        {'text': 'Kotlin', 'score': 0},
        {'text': 'Swift', 'score': 0},
      ],
    },
    // Add more questions here
  ];

  int _questionIndex = 0;
  int _totalScore = 0;

  void answerQuestion(int score) {
    _totalScore += score;
    _questionIndex++;
    notifyListeners();
  }

  int get questionIndex => _questionIndex;
  int get totalScore => _totalScore;
  List<Map<String, dynamic>> get questions => _questions;

  bool get isQuizFinished => _questionIndex >= _questions.length;

  void resetQuiz() {
    _questionIndex = 0;
    _totalScore = 0;
    notifyListeners();
  }
}