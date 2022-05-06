import 'package:flutter/material.dart';
import 'package:flutter_frivia/providers/game_page_provider.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  double? _deviceHeight, _deviceWidth;

  GamePageProvider? _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    // ChangeNotifierProvider 의 child 로 있는 모든 것들은 provider 로 접근이 가능함.
    // 이 경우에는 GamePageProvider 라는 change notifier 를 확장한 클래스임.
    return ChangeNotifierProvider(
      create: (_context) => GamePageProvider(context: context),
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (context) {
        // 여기에 context 가 있음으로써 _buildUI를 감싼 ChangeNotifierProvider 가 제공하는
        // provider 에 접근할 수 있다.
        _pageProvider = context.watch<GamePageProvider>();

        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _deviceHeight! *0.05
              ),
              child: _gameUI(),
            ),
          ),
        );
      },
    );
  }

  Widget _gameUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _questionText(),
        Column(
          children: [
            _trueButton(),
            SizedBox(height: _deviceHeight! * 0.01,),
            _falseButton()
          ],
        )
      ],
    );
  }

  Widget _questionText() {
    return const Text(
      "Test Question 1",
      style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w400
      ),
    );
  }

  Widget _trueButton() {
    return MaterialButton(
      onPressed: () {},
      color: Colors.green,
      minWidth: _deviceWidth! * 0.8,
      height: _deviceHeight! * 0.10,
      child: const Text(
        "True",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _falseButton() {
    return MaterialButton(
      onPressed: () {},
      color: Colors.red,
      minWidth: _deviceWidth! * 0.8,
      height: _deviceHeight! * 0.10,
      child: const Text(
        "False",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }
}
