import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:where/main.dart';
import 'registration.dart';

import 'verify_phone.dart';

import 'forgot_email.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:convert/convert.dart';

class Username {
  final String uname;

  Username(this.uname);
}

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  double _loady = 0.0;
  void getPermission() async {
    print("getPermission");
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.storage,
    // ].request();
  }

  final cryptor = new PlatformStringCryptor();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final _minpad = 5.0;

  login(username, password) async {
    var url = Uri.http('52.74.221.135:5000', '/login');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          "uname": username,
          "password": password,
        }));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['status'];
      if (itemCount != null) {
        print('Here is the returned token: $itemCount.');
        return 0;
      } else {
        print('Here is the returned token: $itemCount.');
        // print('Login successful with status: ${response.statusCode}.');
        return 1;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 2;
    }
  }

  local_store() async {}

  // retrieving_keys() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey("userData")) {
  //     return "No user key found";
  //   }
  //   final extractedUserData =
  //       json.decode(prefs.getString("userData")) as Map<String, Object>;
  //   final k_username = extractedUserData["k_username"];
  //   print("Username Key: " + k_username.toString());
  //   return k_username;
  // }

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
                new Opacity(
                    opacity: _loady,
                    child: new Padding(
                        padding: const EdgeInsets.only(left: 270.0, top: 80.0),
                        child: SizedBox(
                          height: 10.0,
                          width: 10.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ))),
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                    child: Text(
                      "로그인",
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
                    child: TextField(
                      controller: myController1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: '사용자 이름',
                          hintText: 'e.g. Alex123',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                    child: TextField(
                      controller: myController2,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: '암호',
                          hintText: 'only characters and numbers are allowed',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),

                Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  // child:
                  // Expanded(
                  // child:Padding(
                  //      padding: EdgeInsets.only(top: _minpad,bottom: _minpad),
                  //   child:
                  child: ButtonTheme(
                      minWidth: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('로그인'),
                        onPressed: () async {
                          setState(() {
                            _loady = 1.0;
                          });
                          debugPrint("Login is pressed");

                          //****************************   Encryption   **********************************************************
                          // final String k1 = await cryptor.generateRandomKey();
                          // final String k2 = await cryptor.generateRandomKey();
                          //
                          // final String encrypted1 =
                          // await cryptor.encrypt(myController1.text, k1);
                          // final String encrypted2 =
                          // await cryptor.encrypt(myController2.text, k2);
                          //
                          // final String F1 = encrypted1;
                          // final String F2 = encrypted2;
                          // print("F1 :" + F1.toString());
                          // print("F2 :" + F2.toString());
                          //****************************   Encryption   **********************************************************

//************************************************************************************************
                          final login_result = await login(
                              myController1.text, myController2.text);
                          setState(() {
                            _loady = 0.0;
                          });
                          print(
                              "login result: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" +
                                  login_result.toString());

                          //***********************************************************************************
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //       // return Sensor();
                          //     }));
                          // final ret = await retrieving_keys();
                          // print("User key : " + ret.toString());

                          if (login_result.toString() == "0") {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                              return new VerifyForm(uname: myController1.text);
                            }));
                          } else {
                            print("login is not successfull");
                          }
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return MainForm();
                          // }));
                        },
                        elevation: 20.0,
                      )),
                ),

                // ),
                Padding(
                    padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text('레지스터'),
                      onPressed: () {
                        setState(() {
                          _loady = 1.0;
                        });
                        debugPrint("Signup is pressed");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegForm();
                        }));
                      },
                      elevation: 20.0,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  child: TextButton(
                      child: Text('비밀번호를 잊으 셨나요?'),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ForgotForm();
                        }));
                      }),

                  // Text('Forgot Password?'),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 1.0, bottom: 1.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      child: Text('우회로'),
                      onPressed: () async {
                        debugPrint("Bypass is Pressed");
                        // String uid=await genuuid();
                        await writeuuid("84887230-ca93-11eb-9234-677e39cede1e");
                        //String uu=await getuuid();
                        print(
                            "This is uuid 84887230-ca93-11eb-9234-677e39cede1e");

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MyApp();
                        }));
                      },
                      elevation: 20.0,
                    )),
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/login_fig.png');
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

Future<void> writeuuid(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('stringValue', text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint("A new content,i.e. ${text} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}

Future<String> getuuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('stringValue');
  return stringValue;
}

Future<String> genuuid() async {
  var uuid = Uuid();
  String varuuid;

  int _x = 2;

  uuid.v1(options: {
    'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
    'clockSeq': 0x1234,
    'mSecs': new DateTime.utc(2011, 11, 01).millisecondsSinceEpoch,
    'nSecs': 5678
  });

  String checker_uid = uuid.v1().toString();
  List<int> bytes_uuid = utf8.encode(checker_uid);
  print(bytes_uuid);
  var result = hex.encode(bytes_uuid);
  return checker_uid;
}
