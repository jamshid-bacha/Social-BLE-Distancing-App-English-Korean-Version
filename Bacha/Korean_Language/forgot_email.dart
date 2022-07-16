import 'package:flutter/material.dart';
import 'package:where/forgot_email_newpassword.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Email {
  final String email;

  Email(this.email);
}

class ForgotForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotFormState();
  }
}

class _ForgotFormState extends State<ForgotForm> {
  final myController_email = TextEditingController();
  final myController_code = TextEditingController();
  final _minpad = 5.0;
  bool _x = false;

  forgotemail(email) async {
    var url = Uri.http('52.74.221.135:5000', '/sendotpviaemail');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{"email": email}));
    print("Status Code");
    print(response.statusCode);
    print("Json Response");
    print(convert.jsonDecode(response.body));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['status'];
      if (itemCount != null) {
        print('Here is the returned token: $itemCount.');
        return 0;
      } else {
        // print('Here is the returned token: $itemCount.');
        print(
            'Password update successful with status: ${response.statusCode}.');
        return 1;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 2;
    }
  }

  verify_verification(email, otp) async {
    var url = Uri.http('52.74.221.135:5000', '/verifyuserotp');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            convert.jsonEncode(<String, dynamic>{"email": email, "otp": otp}));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print("Yo!!!Response is this:");
      print(jsonResponse);
      var itemCount = jsonResponse['status'];
      if (itemCount == 200) {
        print('Here is the returned token: $itemCount.');
        print(jsonResponse["status"]);
        return 0;
      } else {
        // print('Here is the returned token: $itemCount.');
        print(
            'Verification successful with status: ${jsonResponse["status"]}. and ${itemCount}.');
        return 1;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 2;
    }
  }

  local_store() async {}

  @override
  Widget build(BuildContext context) {
    //TextStyle textStyle=Theme.of(context).textTheme.title;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(_minpad * 2),
            child: Column(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding:
                        EdgeInsets.only(top: _minpad * 3, bottom: _minpad * 10),
                    child: Text(
                      "비밀번호를 잊으 셨나요",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 40.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    )),

                Padding(
                    padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              // child: Padding(
                              padding: EdgeInsets.only(
                                  top: _minpad, bottom: _minpad),
                              child: TextField(
                                controller: myController_email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: '이메일 입력',
                                    hintText: 'e.g.xyz@gotmail.com',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              )),
                        ),
                        Container(
                          width: _minpad * 2,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: _minpad, bottom: _minpad),
                          // child: Expanded(
                          child: SizedBox(
                              width: 70.0,
                              height: 50.0,
                              child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                child: Text('코드 보내기'),
                                onPressed: () async {
                                  _onCheckPushed(true);
                                  debugPrint("Send Code is pressed");
                                  final login_result = await forgotemail(
                                      myController_email.text);
                                  print("OK");
                                  if (login_result.toString() == "2") {
                                    showAlertDialog(context);
                                  }
                                  // Navigator.push(context, MaterialPageRoute(builder: (
                                  //     context) {
                                  //   return ResetForm();
                                  // }
                                  // ));
                                },
                                elevation: 5.0,
                              )),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                    child: TextField(
                      enabled: _x,
                      controller: myController_code,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: '인증 코드 입력',
                          hintText: 'e.g. XXXXX',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),

                Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  // child: Expanded(
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('다음'),
                        onPressed: () async {
                          //*************************************************************************************************
                          debugPrint("Next is not");
                          final verifyresult = await verify_verification(
                              myController_email.text,
                              int.parse(myController_code.text));
                          if (verifyresult.toString() == "0") {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                              return new ResetForm(
                                  email: myController_email.text);
                            }));
                          } else {
                            showAlertDialog2(context);
                          }

                          //*************************************************************************************************
                        },
                        elevation: 20.0,
                      )),
                ),
                //
              ],
            )),
      ),
    );
  }

  void _onCheckPushed(bool newSelected) {
    setState(() {
      this._x = newSelected;
    });
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/forgot_fig.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.only(
          left: _minpad * 10, right: _minpad * 10, top: _minpad * 10),
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("확인"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("경보"),
    content: Text("이메일이 올바르지 않습니다."),
    actions: [
      new FlatButton(
        child: new Text('확인'),
        onPressed: () {
          //Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ForgotForm();
          }));
        },
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog2(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("경보"),
    content: Text("확인 코드가 올바르지 않습니다."),
    actions: [
      new FlatButton(
        child: new Text('확인'),
        onPressed: () {
          //Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ForgotForm();
          }));
        },
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
