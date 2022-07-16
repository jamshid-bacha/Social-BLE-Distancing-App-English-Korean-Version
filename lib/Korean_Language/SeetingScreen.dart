import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where/main.dart';

import 'package:flutter_restart/flutter_restart.dart';

class KLanguageScreen extends StatelessWidget {
  checklang() {
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("CCR_Lab_Plus",
              style: TextStyle(fontSize: 24.0, color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.blue[200]),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/MyApp');
                },
                child: new Text(''),
              ),
              Center(
                child: new Image.asset(
                  'images/Contact_tracing.jfif',
                  width: 220,
                  height: 220,
//fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 32, right: 16, bottom: 8),
                child: Text(
                  'Covid-19 연락처 추적 앱!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      //  color: Color(COLOR_PRIMARY),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Text(
                  '가능한 한 많은 사람들이 COVIDTracer 앱을 활성화하면 감염 사슬을 조기에 끊을 수 있습니다.\n\n 언어를 선택하십시오.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //   primary: Color(COLOR_PRIMARY),
                      primary: Colors.white,
                      textStyle: TextStyle(color: Colors.black),
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () {
                      pleasewritemylanguage(0);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MyApp()),
                      // );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialog(context));
                    },
                    child: Text(
                      'English',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    // onPressed: () => new LoginForm(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //   primary: Color(COLOR_PRIMARY),
                      primary: Colors.white,
                      textStyle: TextStyle(color: Colors.black),
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(
                          color: Colors.black,
                          //    color: Color(COLOR_PRIMARY),
                        ),
                      ),
                    ),
                    onPressed: () {
                      pleasewritemylanguage(1);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MyAppKorean()),
                      // );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPDialog(context));
                    },
                    child: Text(
                      '한국어',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    // onPressed: () => new RegForm(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 20, right: 16, bottom: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

pleasewritemylanguage(int text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('korean', text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint(
      "Your korean value ,i.e. ${text} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Language'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Your Language is change to English! You need to restart app."),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () async {
          Navigator.of(context).pop();
          final result = await FlutterRestart.restartApp();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Ok'),
      ),
    ],
  );
}

Widget _buildPDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('언어'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("귀하의 언어는 이미 한국어입니다!. 메인 화면으로 돌아 가기"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('확인'),
      ),
    ],
  );
}
