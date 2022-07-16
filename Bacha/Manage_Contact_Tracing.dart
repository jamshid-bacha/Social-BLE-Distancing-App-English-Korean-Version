import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'CCR_Lab_Plus',
    home: ManageContact(),
  ));
}

class ManageContact extends StatelessWidget {
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
                'Contact tracing helps protect \n\nyou and others from coronavirus        \n\n(COVID-19).\n\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                  'Contact tracing is the process of identifying,        \n\nassessing, and managing people who have          \n\nbeen exposed to a disease to prevent           \n\nonward transmission. When systematically         \n\napplied, contact tracing will break the chains          \n\nof transmission of COVID-19 and is an           \n\nessential public health tool for controlling           \n\nthe virus.\n\n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              new Text(
                'Contact tracing                                                                 \n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                  'To protect patient privacy, contacts are only   \n\ninformed that they may have been exposed \n\nto a patient with the infection. They are not \n\ntold the identity of the patient who may                    \n\nhave exposed them.\n\n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              new Text(
                  'Should not make much difference to battery \n\nlife.                    \n',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontFamily: 'Arial Black',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              new Text(
                  'cannot track your location.                                                  \n',
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
