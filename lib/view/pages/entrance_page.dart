import 'package:flutter/material.dart';
import 'package:flutter_frivia/common/entrance_page_error_message.dart';
import 'package:flutter_frivia/common/util/max_question_count_validate.dart';
import 'package:flutter_frivia/model/question_configuration_data.dart';
import 'package:flutter_frivia/resources/theme_colors.dart';
import 'package:flutter_frivia/resources/theme_strings.dart';
import 'package:flutter_frivia/view/pages/game_page.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../common/question_config.dart';

class EntrancePage extends StatefulWidget {
  const EntrancePage({Key? key}) : super(key: key);

  @override
  State<EntrancePage> createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage>
    with SingleTickerProviderStateMixin {
  late double _deviceHeight, _deviceWidth;
  bool _isButtonEnabled = false;
  late String selectedCategory;
  String questionCount = '10';
  int pointValue = 1;

  late List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = QuestionConfig.categoryMap.keys.toList();
    selectedCategory = categories.first;
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _appName(),
            _nameContent(_deviceWidth, "Category", _categoryDropDown()),
            _nameContent(_deviceWidth, "Difficulty", _difficultyBar()),
            _nameContent(_deviceWidth, "Question Count", _questionCount()),
            _startGameButton()
          ],
        ),
      ),
    ));
  }

  Widget _appName() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: const Text(
        "Frivia",
        style: TextStyle(
            color: Colors.white, fontSize: 50, fontWeight: FontWeight.w100),
      ),
    );
  }

  Widget _nameContent(double deviceWidth, String name, Widget content) {
    return SizedBox(
      width: deviceWidth * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w100),
            ),
          ),
          content
        ],
      ),
    );
  }

  Widget _categoryDropDown() {
    return DropdownButton(
      value: selectedCategory,
      items: categories.map((e) {
        return DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Roboto'),
            ));
      }).toList(),
      onChanged: (_value) {
        setState(() {
          selectedCategory = _value.toString();
        });
      },
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      dropdownColor: ThemeColors.dropDownMenuBackground,
      underline: Container(),
    );
  }

  Widget _difficultyBar() {
    Color pointerColor = Colors.lightBlue;
    if (pointValue == 1) {
      pointerColor = Colors.lightBlue;
    } else if (pointValue == 2) {
      pointerColor = Colors.white;
    } else {
      pointerColor = Colors.redAccent;
    }
    return SizedBox(
      width: _deviceWidth * 0.8,
      child: SfLinearGauge(
        minimum: 1,
        maximum: 3,
        axisTrackExtent: 30,
        interval: 1,
        minorTicksPerInterval: 0,
        orientation: LinearGaugeOrientation.horizontal,
        markerPointers: [
          LinearShapePointer(
            value: pointValue.toDouble(),
            onChanged: (value) {
              setState(() {
                pointValue = value.round();
              });
            },
            color: pointerColor,
            enableAnimation: true,
            animationDuration: 2000,
            animationType: LinearAnimationType.linear,
          ),
        ],
        axisTrackStyle: const LinearAxisTrackStyle(
            color: Colors.white,
            thickness: 20,
            edgeStyle: LinearEdgeStyle.bothCurve,
            gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.redAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp)),
        axisLabelStyle: const TextStyle(color: Colors.white, fontSize: 15),
        labelFormatterCallback: (label) {
          switch (label) {
            case '1':
              return 'Easy';
            case '2':
              return 'Medium';
            default:
              return 'Hard';
          }
        },
      ),
    );
  }

  Widget _questionCount() {
    return TextField(
      onChanged: (text) {
        setState(() {
          questionCount = text;
        });
      },
      onSubmitted: (text) {
        int result = MaxQuestionCountValidate.invoke(text.replaceAll(' ', ''));
        if (result < 0) {
          showDialog(
              context: context,
              builder: (BuildContext _context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Text(
                    EntrancePageErrorMessage.messageMap[result],
                  ),
                );
              });
          setState(() {
            _isButtonEnabled = false;
          });
        } else {
          setState(() {
            _isButtonEnabled = true;
          });
        }
      },
      decoration: const InputDecoration(
        labelText: ThemeStrings.ENTRANCE_INPUT_QUESTION_COUNT,
        labelStyle: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Colors.lightBlue),
        ),
      ),
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    );
  }

  Widget _startGameButton() {
    return MaterialButton(
      child: const Text(
        ThemeStrings.ENTRANCE_BUTTON,
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
      enableFeedback: _isButtonEnabled,
      height: _deviceHeight * 0.08,
      minWidth: _deviceWidth * 0.4,
      color: _isButtonEnabled ? Colors.lightBlue : Colors.white12,
      // shape: ,
      onPressed: () {
        if (_isButtonEnabled) {
          QuestionConfigurationData data =
              GetIt.instance.get<QuestionConfigurationData>();
          data.selectedCategory = QuestionConfig.categoryMap[selectedCategory]!;
          data.selectedMaxQuestion = int.parse(questionCount);
          data.selectedDifficulty = QuestionConfig.difficulties[pointValue - 1];

          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return GamePage();
          }));
        }
      },
    );
  }
}
