import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where/radiobutton.dart';
import 'package:where/radiobuttonkorean.dart';

import 'First_Screen.dart';
import 'Korean_Language/First_Screen.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  checklang() {
    return 1;
  }

  int _selectedGender = 0;

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Uploading Data!'),
      content: RadioCheck(),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildKPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('데이터 업로드!'),
      content: KRadioCheck(),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 20, right: 16, bottom: 8),
            ),
            Center(
              child: new Image.asset(
                'images/Contact_tracing.jfif',
                width: 220,
                height: 220,
                alignment: Alignment.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 32, right: 16, bottom: 8),
              child: Text(
                'Covid-19 연락처 추적 앱!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Text(
                '가능한 한 많은 사람들이 COVIDTracer 앱을 활성화하면 감염 사슬을 조기에 끊을 수 있습니다.\n\n 언어를 선택하십시오.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                  child: Text(
                    'English',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
                    pleasewritemylanguage(1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstScreen()),
                    );
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
          ],
        ),
      ),
    );
  }
}

pleasewritemylanguage(int text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('korean', text);
}
