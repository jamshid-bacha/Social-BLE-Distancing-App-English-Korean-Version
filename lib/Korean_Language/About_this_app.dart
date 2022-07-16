import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'CCR_Lab_Plus',
    home: KAboutthisapp(),
  ));
}

class KAboutthisapp extends StatelessWidget {
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/appbackground.jfif"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/MyApp');
                },
                child: new Text(''),
              ),
              new Text(
                '이 앱의 작동 원리                                                          \n        ',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                '이 앱은 연락처 추적 기술을 사용하여 자신과 \n\n타인을 보호하여 우리 모두가 좋아하는 일로 돌아갈 \n\n수 있도록합니다.\n\n앱은 주변의 다른 앱 사용자를 알리고 기록합니\n\n다. 해당 사용자가 나중에 COVID-19에 양성 반응\n\n을 보이면 조언과 함께 알림을 받게됩니다. \n\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                '우리의 정책                                                                   \n                ',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                '당사의 정책은 앱 사용, 당사가 귀하의 데이터를 \n\n사용하는 방법 및 모든 사람이 사용할 수 있도록 \n\n앱을 설계하는 방법에 대한 중요한 정보를 알려줍\n\n니다.\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                '앱을 사용하여 자신과 타인을 보호 해주셔서 감사합니다\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
