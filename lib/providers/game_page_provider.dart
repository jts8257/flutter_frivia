import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ChangeNotifier 는 class 내부에서 발생한 변화(change) 를 알아차리도록 도와준다.
// 이 클래스는 http 통신을 담당할 것이다.
class GamePageProvider extends ChangeNotifier {

  final Dio _dio = Dio();
  final int _maxQuestions = 10;
  List? questions;
  BuildContext context;

  GamePageProvider({required this.context}) {
    // dio 의 option 을 변경한다.
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    _getQuestionsFromAPI();
  }

  //https://opentdb.com/api.php?amount=10&difficulty=easy
  Future<void> _getQuestionsFromAPI() async {
    var _response = await _dio.get(
        '',
        queryParameters: {
          'amount': _maxQuestions,
          'type': 'boolean',
          'difficulty' : 'easy'
        }
    );
    var _data = jsonDecode(_response.toString());
    print(_data);
    questions = _data["results"];
  }
}