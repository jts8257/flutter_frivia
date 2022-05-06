import 'package:flutter/material.dart';
import 'package:flutter_frivia/pages/game_page.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Frivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
        fontFamily: 'ArchitectsDaughter'
      ),
      home: GamePage(),
    );
  }
}



