import 'package:flutter/material.dart';

import 'login.dart';
import 'registration.dart';

class FirstScreen extends StatelessWidget {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginForm()),
                    );
                  },
                  child: Text(
                    '로그인',
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
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegForm()),
                    );
                  },
                  child: Text(
                    '가입하기',
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
