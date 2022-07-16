import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'CCR_Lab_Plus',
    home: Aboutthisapp(),
  ));
}

class Aboutthisapp extends StatelessWidget {
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
                'How this app works                                                        \n        ',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                'This app uses contact tracing technology to \n\nhelp protect yourself and others so we can     \n\nall get back to the things we love.\n\n\nThe app notices and logs other nearby app      \n\nusers. If any of those user later test positive \n\nfor COVID-19, You\'ll receive an alert with           \n\nadvice. \n\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                'Our policies                                                                   \n                ',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                'Our policies tells you important information   \n\nabout using the app, how we use your data,        \n\nand how the app is designed to be usable by \n\neveryone.\n\n\n',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Arial Black',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              new Text(
                'Thank you for protecting yourself and others by using the app\n',
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
