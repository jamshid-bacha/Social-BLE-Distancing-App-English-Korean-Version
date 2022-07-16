import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'main.dart';

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
        pleasewritemyuuid(jsonResponse['u_beaconid']);
        pleasewritemytoken(jsonResponse['token']);
        return 0;
      } else {
        return 1;
      }
    } else {
      return 2;
    }
  }

  local_store() async {}

  @override
  Widget build(BuildContext context) {
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
                      "Phone Verification",
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
                          labelText: 'Enter OTP',
                          hintText: 'XXXXX',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),

                Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Verify'),
                        onPressed: () async {
                          debugPrint("Verify is pressed");

                          final login_result = await verify(
                              widget.uname, int.parse(myController1.text));
                          var random = new Random();
                          if (login_result.toString() == "0") {
                            _writeIndicator(1.toString());
                            pleasewritemyusername(widget.uname);
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                              return MyApp();
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
                      child: Text('Resend OTP'),
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
}

_writeIndicator(String text) async {
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/indicator.txt";
    final File file = File(fullPath);
    await file.writeAsString(text);
  } catch (e) {}
}

writeToken(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('stringValue', text);
}

showAlertDialog(BuildContext context, uuname) {
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("OTP is not correct"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
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
}

pleasewritemyusername(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('myusername', text);
}

pleasewritemytoken(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('tokyboy', text);
}
