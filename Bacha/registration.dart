import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:where/verify_phone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where/login.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:convert/convert.dart';

final imgUrl =
    "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/txt/dummy.txt";
var dio = Dio();

class Username {
  final String uname;

  Username(this.uname);
}

class RegForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegFormState();
  }
}

class _RegFormState extends State<RegForm> {
  String _countrycoder = "";
  final _minpad = 5.0;
  var _noter = 0;
  var _currentCat = 'Male';
  double _loady = 0.0;
  var _currentStat = 'Normal';

  bool _passworder = false;
  bool _usernamer = false;
  bool _emailer = false;
  bool _fullnamer = false;
  bool _numberer = false;

  // var _cat = ['Citizen', 'Health Personal', 'Policy Maker'];
  var _cat = ['Male', 'Female'];
  var _stat = ['Normal', 'Exposed', 'Infected'];
  final myController_username = TextEditingController();
  final myController_password = TextEditingController();
  final myController_phonenumber = TextEditingController();
  final myController_email = TextEditingController();
  final myController_age = TextEditingController();
  final myController_fullname = TextEditingController();

  final cryptor = new PlatformStringCryptor();

  signup(username, password, fullname, contact_num, email, age, gender,
      u_beaconid) async {
    var url = Uri.http('52.74.221.135:5000', '/register');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "uname": username,
          "password": password,
          "ph_no": contact_num,
          "email": email,
          "age": age,
          "gender": gender,
          "u_beaconid": u_beaconid,
          "fname": fullname
        }));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var itemCount = jsonResponse['status'];
      if (itemCount == 200) {
        return 0;
      } else if (itemCount != 200) {
        return 1;
      }
    } else {}
  }

  void getPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  Future write_public_Dat(
      Dio dio, String url, String savePath, String dataa) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      File file = new File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      file.writeAsString(dataa);
      await raf.close();
    } catch (e) {}
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {}
  }

  void downloadcsvfile(String dataa) async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/CCR_Korea.txt";
    write_public_Dat(dio, imgUrl, fullPath, dataa);
  }

  //***************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
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
              padding: EdgeInsets.only(top: _minpad, bottom: _minpad * 6),
              child: Text(
                "Registration",
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 40.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: _minpad, bottom: _minpad, left: _minpad, right: _minpad),
              child: TextField(
                controller: myController_username,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'e.g. Alex123',
                    errorText:
                        _usernamer ? 'Username must be alphanumeric' : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: _minpad, bottom: _minpad, left: _minpad, right: _minpad),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        // child: Padding(
                        padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                        child: TextField(
                          controller: myController_fullname,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'First, middle and last name',
                              errorText: _fullnamer
                                  ? 'Please enter a valid name'
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                  ),
                  SizedBox(
                      width: 100,
                      child: TextField(
                        controller: myController_age,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Age',
                            hintText: 'XX',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: _minpad, bottom: _minpad, left: _minpad, right: _minpad),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        // child: Padding(
                        padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                        child: TextField(
                          controller: myController_email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'e.g.xyz@hotmail.com',
                              errorText: _emailer
                                  ? 'Password should contain alphanumerics and a character'
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                  ),
                  Container(
                    width: _minpad * 2,
                  ),
                  Container(
                      width: _minpad * 30,
                      // child:Expanded(
                      child: DropdownButton<String>(
                          hint: Text('Category'),
                          icon: const Icon(Icons.person),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.blueGrey),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          items: _cat.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentCat,
                          onChanged: (String newValueSelected) {
                            _onDroDownItemSelected(newValueSelected);
                          }))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: _minpad, bottom: _minpad, left: _minpad, right: _minpad),
              child: Row(
                children: <Widget>[
                  CountryCodePicker(
                    onChanged: print,
                    initialSelection: 'KR',
                    favorite: ['+39', 'FR'],
                    showFlagDialog: false,
                    comparator: (a, b) => b.name.compareTo(a.name),
                    //Get the country information relevant to the initial selection
                    onInit: (code) {
                      _countrycoder = code.dialCode.toString();
                    },
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                        child: TextField(
                          controller: myController_phonenumber,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: 'e.g. 1237576894',
                              errorText: _numberer
                                  ? 'Please enter a valid phone#'
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(
                top: _minpad, bottom: _minpad, left: _minpad, right: _minpad),
            child: TextField(
              controller: myController_password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: 'New Password',
                  hintText: 'only characters and numbers are allowed',
                  errorText: _passworder
                      ? 'Password should contain alphanumerics and a character'
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
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
                  child: Text('Register'),
                  onPressed: () async {
                    try {
                      assert(EmailValidator.validate(myController_email.text));
                    } catch (e) {
                      setState(() {
                        _noter = 1;
                      });
                    }

                    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
                    setState(() {
                      _loady = 1.0;
                    });
                    int dd = await _readIndicator();

                    setState(() {
                      _loady = 0.0;
                    });
                    String myuuid = await pleasegetmeuuid();
                    String phony = _countrycoder.toString() +
                        myController_phonenumber.text;
                    if (dd == 0) {
                      if (_noter == 1) {
                        setState(() {
                          _emailer = true;
                        });
                      } else if (myController_username.text.contains(' ')) {
                        showAlertDialog5(context);
                      } else if (myController_fullname.text
                          .contains(new RegExp(r'[0-9_\-=@,/.;]'))) {
                        setState(() {
                          _fullnamer = true;
                        });
                      } else if (myController_phonenumber.text.length != 10) {
                        setState(() {
                          _numberer = true;
                        });
                      } else if (myController_password.text.length < 8) {
                        showAlertDialog9(context);
                      } else if (!myController_password.text
                              .contains(new RegExp(r'[_\-=@,/.;]')) ||
                          !myController_password.text
                              .contains(new RegExp(r'[A-Z]')) ||
                          !myController_password.text
                              .contains(new RegExp(r'[a-z]')) ||
                          !myController_password.text
                              .contains(new RegExp(r'[0-9]'))) {
                        setState(() {
                          _passworder = true;
                        });
                      } else if (validCharacters
                              .hasMatch(myController_username.text) !=
                          true) {
                        setState(() {
                          _usernamer = true;
                        });
                      } else {
                        final signup_response = await signup(
                            myController_username.text,
                            myController_password.text,
                            myController_fullname.text,
                            phony,
                            myController_email.text,
                            myController_age.text,
                            _currentCat,
                            myuuid);

                        if (myController_username.text == "" ||
                            myController_password.text == "" ||
                            myController_fullname.text == "" ||
                            myController_phonenumber.text == "" ||
                            myController_email.text == "" ||
                            myController_age.text == "") {
                          showAlertDialog3(context);
                        } else if (signup_response.toString() == "0") {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                            return new VerifyForm(
                                uname: myController_username.text);
                          }));
                        } else {
                          showAlertDialog2(context);
                        }
                      }
                    } else {
                      showAlertDialog(context);
                    }
                  },
                  elevation: 10.0,
                )),
          ),
          Padding(
              padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text('Login'),
                onPressed: () {
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginForm();
                    }));
                  }
                },
                elevation: 20.0,
              )),
        ],
      )),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/register_fig.png');
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

  void _onDroDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentCat = newValueSelected;
    });
  }

  void _onDroDownItemSelected2(String newValueSelected) {
    setState(() {
      this._currentStat = newValueSelected;
    });
  }
}

Future<bool> _getBoolValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool boolValue = prefs.getBool('boolValue');
  return boolValue;
}

Future<int> _readIndicator() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/indicator.txt";
    final File file = File(fullPath);
    text = await file.readAsString();
    indicator = 1;
  } catch (e) {
    indicator = 0;
  }
  return indicator;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(
        "Making a new account is prohibited as per terms and conditions. By clicking 'OK', you would be prompted towards Login page"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          //Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/ref_signup_Data.txt');
  await file.writeAsString(text);
}

showAlertDialog2(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("Username already exists!"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          //Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog3(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("You must fill all fields for registration to continue!"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          //Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> pleasegetmeuuid() async {
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
  List<int> chunk_bytes_uuid = [];
  for (var i = 0; i < 16; i += 1) {
    chunk_bytes_uuid.add(bytes_uuid[i]);
  }
  var result = hex.encode(chunk_bytes_uuid);
  return result.toString();
}

showAlertDialog4(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Error",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text("Please Enter a Valid Email Address"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog5(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Error",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text("There must be no space in Username"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog6(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Error",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text("Full Name must only contain alphabets"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog7(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Error",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text("Please enter a valid phone number"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog8(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Error",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text("Username must contain alphanumeric characters"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
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

showAlertDialog9(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Error",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text("Password length must be atleast 8"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog10(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text(
      "Error",
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: Text(
        "Password must contain lowercase and upercase alphabets, as well as number and special characters"),
    actions: [
      new FlatButton(
        child: new Text('OK'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RegForm();
          }));
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
