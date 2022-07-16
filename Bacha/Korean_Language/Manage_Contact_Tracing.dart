import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'CCR_Lab_Plus',
    home: KManageContact(),
  ));
}

class KManageContact extends StatelessWidget {
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
                '연락처 추적은 귀하와 다른 사람\n\n을 코로나 바이러스 (COVID-19)         \n\n로부터 보호하는 데 도움이됩니       \n\n다.\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                  '접촉 추적은 질병에 노출 된 사람들을 식별, 평가 \n\n및 관리하여 향후 전파를 방지하는 프로세스입니\n\n다. \n\n체계적으로 적용되면 접촉 추적은 COVID-19의 \n\n전파 사슬을 끊고 바이러스를 제어하는 ​​데 필수적 \n\n인 공중 보건 도구입니다.\n\n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              new Text(
                '연락처 추적                                                                 \n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                  '환자의 개인 정보를 보호하기 위해 연락처는 감염\n\n된 환자에게 노출되었을 수 있다는 사실 만 알립\n\n니다. 노출되었을 수있는 환자의 신원을 알려주지 \n\n않습니다.\n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              new Text('배터리 수명에 큰 차이가 없어야합니다.                    \n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              new Text(
                  '위치를 추적 할 수 없습니다.                                     \n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
