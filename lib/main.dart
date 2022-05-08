import 'package:flutter/material.dart';
import 'package:flutter_frivia/model/question_configuration_data.dart';
import 'package:flutter_frivia/view/pages/entrance_page.dart';
import 'package:get_it/get_it.dart';

import 'resources/theme_colors.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    configApp();
    return MaterialApp(
      title: 'Frivia',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: ThemeColors.colorMainBackground,
          fontFamily: 'ArchitectsDaughter'),
      home: EntrancePage(),
    );
  }

  void configApp() {
    if (!GetIt.instance.isRegistered<QuestionConfigurationData>()) {
      GetIt.instance.registerSingleton(QuestionConfigurationData());
    }
  }
}
