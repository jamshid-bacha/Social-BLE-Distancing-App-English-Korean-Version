import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:where/main.dart';

import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:math';

class Username {
  final String uname;

  Username(this.uname);
}

class VerifyForm extends StatefulWidget {
  final String uname;

  VerifyForm({Key key, this.uname}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _VerifyFormState();
  }
}

class _VerifyFormState extends State<VerifyForm> {
  final _minpad = 5.0;
  final myController1 = TextEditingController();

  void getPermission() async {
    print("getPermission");
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  verify(username, otp) async {
    var url = Uri.http('52.74.221.135:5000', '/verifyOTP');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, dynamic>{
          "uname": username,
          "otp": otp,
        }));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['token'];
      if (itemCount != null) {
        print('Here is the returned token: $itemCount.');
        print("u_beaconid:");
        print(jsonResponse['u_beaconid']);
        pleasewritemyuuid(jsonResponse['u_beaconid']);
        print("Token:");
        print(jsonResponse['token']);
        pleasewritemytoken(jsonResponse['token']);
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
                        EdgeInsets.only(top: _minpad, bottom: _minpad * 10),
                    child: Text(
                      "전화 확인",
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
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'OTP 입력',
                          hintText: 'XXXXX',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),

                Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  // child:Expanded(
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('검증'),
                        onPressed: () async {
                          debugPrint("Verify is pressed");
                          //************************************************************************************************
                          final login_result = await verify(
                              widget.uname, int.parse(myController1.text));
                          print("username: ${widget.uname}");
                          print("Verification Result:   " +
                              login_result.toString());
                          //  String path =
                          //  await ExtStorage.getExternalStoragePublicDirectory(
                          //      ExtStorage.DIRECTORY_DOWNLOADS);
                          //  String fullPath = "$path/verifier.txt";
                          // // print('full path ${fullPath}');
                          //  //***************************Download a file from URL**********************
                          //  // download_from_url(dio, imgUrl, fullPath);
                          //  //************************************************************************
                          //  File file = File(fullPath);
                          var random = new Random();
                          //_write(1.toString());

                          //***********************************************************************************
                          if (login_result.toString() == "0") {
                            _writeIndicator(1.toString());
                            // writeToken(login_result.toString());
                            // first get the uuid from response from post request of OTP Verification
                            //pleasewritemyuuid(String text);
                            pleasewritemyusername(widget.uname);
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                              return new MyApp();
                            }));
                          } else {
                            showAlertDialog(context, widget.uname);
                          }
                        },
                        elevation: 20.0,
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text('OTP 재전송'),
                      onPressed: () async {
                        debugPrint("Resend OTP is pressed");
                      },
                      elevation: 20.0,
                    )),
                //
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/verify_fig.png');
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

_write(String text) async {
  String path = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  String fullPath = "$path/verifier.txt";
  final File file = File(fullPath);
  await file.writeAsString(text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint("A verifier file with new content,i.e. ${text} has been stored ");
  debugPrint(
      "*********************************************************************************************");
}

_writeIndicator(String text) async {
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/indicator.txt";
    final File file = File(fullPath);
    await file.writeAsString(text);
    debugPrint(
        "*********************************************************************************************");
    debugPrint(
        "An indicator file with new content,i.e. ${text} has been stored");
    debugPrint(
        "*********************************************************************************************");
  } catch (e) {
    debugPrint(
        "*********************************************************************************************");
    debugPrint("Couldn't write a file");
    debugPrint(
        "*********************************************************************************************");
  }
}

writeToken(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('stringValue', text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint("A new content,i.e. ${text} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}

showAlertDialog(BuildContext context, uuname) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("OTP is not correct"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          //Navigator.of(context).pop();
          // Navigator.push(context,
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return VerifyForm(uname: uuname);
          }));
          return;
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

pleasewritemyuuid(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('myuuid', text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint("Your uuid ,i.e. ${text} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}

pleasewritemyusername(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('myusername', text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint("Your username ,i.e. ${text} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}

pleasewritemytoken(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('tokyboy', text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint("Your token ,i.e. ${text} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}
