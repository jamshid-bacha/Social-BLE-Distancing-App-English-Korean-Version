import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'First_Screen.dart';
import 'Korean_Language/First_Screen.dart';

import 'login.dart';
import 'main.dart';
import 'registration.dart';
import 'package:flutter_restart/flutter_restart.dart';

class SettingScreen extends StatelessWidget {
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
                  'Covid-19 Contact Tracking App!',
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
                  'If as many people as possible activate the COVIDTracer app, you can break the chain of infection early.\n\nPlease choose your language.',
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
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPDialog(context));
                      // MyAppKorean();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MyAppKorean()),
                      // );
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
        Text("Your Language is already in English!. Go back to main screen"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
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
        Text("귀하의 언어가 영어로 변경되었습니다! 앱을 다시 시작해야합니다."),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () async {
          Navigator.of(context).pop();
          final result = await FlutterRestart.restartApp();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('확인'),
      ),
    ],
  );
}
