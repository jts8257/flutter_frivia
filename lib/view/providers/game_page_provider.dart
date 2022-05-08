import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frivia/model/question_configuration_data.dart';
import 'package:get_it/get_it.dart';

// ChangeNotifier 는 class 내부에서 발생한 변화(change) 를 알아차리도록 도와준다.
// 이 클래스는 http 통신을 담당할 것이다.
class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final questionConfigData = GetIt.instance.get<QuestionConfigurationData>();
  int _maxQuestions = 10;
  List? questions;
  int _currentQuestionCount = 0;
  int _score = 0;
  BuildContext context;

  GamePageProvider({required this.context}) {
    // dio 의 option 을 변경한다.
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    _maxQuestions = questionConfigData.selectedMaxQuestion;
    _getQuestionsFromAPI();
  }

  // https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=boolean
  Future<void> _getQuestionsFromAPI() async {
    print(
        "https://opentdb.com/api.php?amount=${questionConfigData.selectedMaxQuestion}&category=${questionConfigData.selectedCategory}&difficulty=${questionConfigData.selectedDifficulty}&type=boolean");
    var _response = await _dio.get('', queryParameters: {
      'category': questionConfigData.selectedCategory,
      'amount': _maxQuestions,
      'type': 'boolean',
      'difficulty': questionConfigData.selectedDifficulty
    });
    var _data = jsonDecode(_response.toString());
    print("hello ${_data}");
    questions = _data["results"];
    notifyListeners();
    // notifyListeners 를 씀으로써
    // ChangeNotifierProvider(
    // create: (_context) => GamePageProvider(context: context),
    // child: _buildUI(),
    // );
    // 에서 notify 받을 수 있음.
  }

  String getCurrentQuestionText() {
    return questions![_currentQuestionCount]['question'];
  }

  void answerQuestion(String _answer) async {
    bool _isCorrect =
        questions![_currentQuestionCount]['correct_answer'] == _answer;
    _score += _isCorrect ? 1 : 0;
    _currentQuestionCount++;
    // showDialog 가 여기 있는게 맞나? 관심사의 분리에서 벗어난 접근
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            backgroundColor: _isCorrect ? Colors.green : Colors.red,
            title: Icon(_isCorrect ? Icons.check_circle : Icons.cancel_sharp),
            content: Text(
              _isCorrect ? "Correct!" : "Wrong!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          );
        });

    // dialog 가 나오고 나서 1 초 뒤에 화면 제일 위에 있는 걸 화면에서 내리는 로직...
    // 유저의 반응속도가 빠르면 앱의 화면이 다 내려가 버리는 위험이 있다.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    Navigator.pop(context);
    if (_currentQuestionCount == _maxQuestions) {
      endGame();
    } else {
      notifyListeners();
    }
    // 그러니까 provider 내부의 값이 바뀌면 해주는거다.
  }

  Future<void> endGame() async {
    showDialog(
        context: context,
        builder: (BuildContext _cotext) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            title: const Text(
              "End Game!",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            content: Text(
              "Score : $_score/$_maxQuestions",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          );
        });
    await Future.delayed(
      const Duration(seconds: 3),
    );
    Navigator.pop(context);
  }
}
