import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:where/main.dart';
import 'package:where/verify_phone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where/login.dart';
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';

import 'package:email_validator/email_validator.dart';

import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
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
        print('Registration successful with status: ${response.statusCode}.');
        print(jsonResponse["msg"]);
        return 0;
      } else if (itemCount != 200) {
        print("username already exist");
        return 1;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  // void saving_keys(
  //     k_username, k_password, k_contact_num, k_email, k_age, k_gender) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userData = json.encode({
  //     "k_username": k_username,
  //     "k_password": k_password,
  //     "k_contact_num": k_contact_num,
  //     "k_email": k_email,
  //     "k_age": k_age,
  //     "k_gender": k_gender,
  //   });
  //   prefs.setString("userData", userData);
  // }

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   myController1.dispose();
  //   super.dispose();
  // }
  //************************************************************************************************
  void getPermission() async {
    print("getPermission");
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.storage,
    // ].request();
  }

  Future write_public_Dat(
      Dio dio, String url, String savePath, String dataa) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
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
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void downloadcsvfile(String dataa) async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    //String fullPath = tempDir.path + "/boo2.pdf'";
    String fullPath = "$path/CCR_Korea.txt";
    print('full path ${fullPath}');
    write_public_Dat(dio, imgUrl, fullPath, dataa);
  }

  //***************************************************************
  @override
  Widget build(BuildContext context) {
    //TextStyle textStyle=Theme.of(context).textTheme.title;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      // appBar: AppBar(
      //   title: Text('COVID Tracker'),
      // ),
      body: SingleChildScrollView(
          //margin: EdgeInsets.all(_minpad * 2),
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
          // Padding(
          //     padding: EdgeInsets.only(top:_minpad,bottom: _minpad),
          //     child:TextField(
          //       keyboardType: TextInputType.emailAddress,
          //       decoration: InputDecoration(
          //           labelText: 'Email',
          //           hintText: 'e.g.xyz@hotmail.com',
          //           border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(5.0))),
          //     )),
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
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'KR',
                    favorite: ['+39', 'FR'],
                    // countryFilter: ['IT', 'FR'],
                    showFlagDialog: false,
                    comparator: (a, b) => b.name.compareTo(a.name),
                    //Get the country information relevant to the initial selection
                    onInit: (code) {
                      print(
                          "on init ${code.name} ${code.dialCode} ${code.name}");
                      _countrycoder = code.dialCode.toString();
                    },
                  ),
                  Expanded(
                    //******************&&&&&&&&&&&&&&&&&&&&&&&&&&&&***************************
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
                  //*****************&&&&&&&&&&&&&&&&&&&&&&&&&*************************************

                  // Container(
                  //   width: _minpad * 0.1,
                  // ),
                  // Container(
                  //     width: _minpad*20,
                  //     child:
                  //88888888888888888888888888888888888888888888888888888888888888888
                  // Expanded(
                  //   child: Container(
                  //       padding: EdgeInsets.only(
                  //           top: _minpad, bottom: _minpad, left: _minpad * 6),
                  //       child: TextField(
                  //         controller: myController_age,
                  //         keyboardType: TextInputType.number,
                  //         decoration: InputDecoration(
                  //             labelText: 'Age',
                  //             hintText: 'XX',
                  //             border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(5.0))),
                  //       )),
                  // )
                  //88888888888888888888888888888888888888888888888888888888888888
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
                    print(
                        "**********************************************************");
                    try {
                      assert(EmailValidator.validate(myController_email.text));
                    } catch (e) {
                      print("Idiot");
                      setState(() {
                        _noter = 1;
                      });
                      print("var");
                      print(_noter);
                    }
                    //_read();
                    //KEY GENERATION: password of user will be used to generate a random key, in combination with a salt. We have to store salt locally on phone, while password (in original form)
                    //will be stored on server database. In a nutshell, on database, all credentials, except passoword, we be stored on server in encrypted (hased) form
                    //while, a salt be placed securely and locally on smartphones memory. Atleast this way, we can assure that the same key is generated when logging in followed by a signup

                    //**//final String password_of_user = myController5.text;

                    //Gneration of key

                    //**//debugPrint(password_of_user);
                    //** final String salt_name = await cryptor.generateSalt();

                    //**//final String k_name = await cryptor.generateKeyFromPassword(password_of_user , salt_name);

                    //**// final String salt_email = await cryptor.generateSalt();
                    //**// final String k_email = await cryptor.generateKeyFromPassword(password_of_user , salt_email);

                    //**// final String salt_category = await cryptor.generateSalt();
                    //**// final String k_category = await cryptor.generateKeyFromPassword(password_of_user , salt_category);

                    //**// final String salt_phonenumber = await cryptor.generateSalt();
                    //**// final String k_phonenumber = await cryptor.generateKeyFromPassword(password_of_user , salt_phonenumber);

                    //**// final String salt_age = await cryptor.generateSalt();
                    //**// final  String k_age = await cryptor.generateKeyFromPassword(password_of_user , salt_age);

                    //Encryption

//***************************************************************************************************************8
                    // final String encrypted_name =
                    // await cryptor.encrypt(myController1.text, k_name);
                    // final String encrypted_email =
                    // await cryptor.encrypt(myController2.text, k_email);
                    // final String encrypted_category =
                    // await cryptor.encrypt(_currentCat, k_category);
                    // final String encrypted_phonenumber =
                    // await cryptor.encrypt(myController3.text, k_phonenumber);
                    // final String encrypted_age =
                    // await cryptor.encrypt(myController4.text, k_age);
                    //
                    // final String F1 = encrypted_name;
                    // final String F2 = encrypted_email;
                    // final String F3 = encrypted_category;
                    // final String F4 = encrypted_phonenumber;
                    // final String F5 = encrypted_age;

                    // final String F6=password_of_user;
//*****************************************************************************************************************
                    //Decryption: Please note that we will request user to access the salt stored. Form that, in combination with their password, we will generate key, which will generate the decrypted strings.
                    // final String G1 = await cryptor.decrypt(F1, k_name);
                    // final String G2 = await cryptor.decrypt(F2, k_email);
                    // final String G3 = await cryptor.decrypt(F3, k_category);
                    // final String G4 = await cryptor.decrypt(F4, k_phonenumber);
                    // final String G5 = await cryptor.decrypt(F5, k_age);

                    // String currentdat="\n" +
                    //     "Name:" +
                    //     F1 +
                    //     "\n" +
                    //     "Email:" +
                    //     F2 +
                    //     "\n" +
                    //     "Category:" +
                    //     F3 +
                    //     "\n" +
                    //     "Phone#:" +
                    //    F4 +
                    //     "\n" +
                    //     "Age:" +
                    //     F5 +
                    //     "\n" +
                    //    "Password:" +
                    //     F6 +
                    // "\n";

                    // String currentdat="\n" +
                    //     "Name:" +
                    //     salt_name +
                    //     "\n" +
                    //     "Email:" +
                    //     salt_email +
                    //     "\n" +
                    //     "Category:" +
                    //     salt_category+
                    //     "\n" +
                    //     "Phone#:" +
                    //     salt_phonenumber +
                    //     "\n" +
                    //     "Age:" +
                    //     salt_age +
                    //     "\n";
                    //  debugPrint(currentdat);

                    //************************Response Data**************************************

                    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
                    print("Hello, Idiot!!:");
                    print(validCharacters.hasMatch(myController_username.text));

                    setState(() {
                      _loady = 1.0;
                    });
                    int dd = await _readIndicator();

                    setState(() {
                      _loady = 0.0;
                    });
                    String myuuid = await pleasegetmeuuid();
                    print("Junaid, I generated this UUID:");
                    print(myuuid);

                    String phony = _countrycoder.toString() +
                        myController_phonenumber.text;
                    print(
                        "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
                    print(phony);

                    if (dd == 0) {
                      if (_noter == 1) {
                        // showAlertDialog4(context);
                        setState(() {
                          _emailer = true;
                        });
                      } else if (myController_username.text.contains(' ')) {
                        showAlertDialog5(context);
                      } else if (myController_fullname.text
                          .contains(new RegExp(r'[0-9_\-=@,/.;]'))) {
                        // showAlertDialog6(context);
                        setState(() {
                          _fullnamer = true;
                        });
                      } else if (myController_phonenumber.text.length != 10) {
                        // showAlertDialog7(context);
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
                        // showAlertDialog10(context);
                        setState(() {
                          _passworder = true;
                        });
                      } else if (validCharacters
                              .hasMatch(myController_username.text) !=
                          true) {
                        // showAlertDialog8(context);
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
                      print("An account was already made on this phone");
                      showAlertDialog(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //
                      //       return LoginForm();
                      //     }));
                    }

                    //********************************************************************************

//***********************************************************************************************************************************8
                    /*
                        String path =
                       await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);
                         String fullPath = "$path/datSingup.txt";
                         write_public_Dat(dio,imgUrl,fullPath,currentdat);
                       */
//*********************************************************************************************************************************************
//                        _write(currentdat);
                    // bool x = await _getBoolValuesSF();
                    // saving_keys(F1, F6, F4, F2, F5, F3);
                    //**************************************************************************

                    //downloadcsvfile(currentdat);

                    //*****************************************************************************
//                         Directory appDocDirectory = await getApplicationDocumentsDirectory();
//
//                         new Directory(appDocDirectory.path+'/'+'dir').create(recursive: true)
// // The created directory is returned as a Future.
//                             .then((Directory directory) {
//                           print('Path of New Dir: '+directory.path);
//                         });
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
                  debugPrint("Login is pressed");
                  //  debugPrint('Captured data: ${x}');

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
  //Return bool
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
    // debugPrint("A file has been read at ${directory.path}");
    indicator = 1;
  } catch (e) {
    debugPrint("Couldn't read file");
    indicator = 0;
  }
  return indicator;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

showAlertDialog(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
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
  debugPrint(
      "A file with new content,i.e. ${text} has been stored at ${directory.path}");
}

showAlertDialog2(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog3(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
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
  print(bytes_uuid);
  List<int> chunk_bytes_uuid = [];
  for (var i = 0; i < 16; i += 1) {
    chunk_bytes_uuid.add(bytes_uuid[i]);
  }
  var result = hex.encode(chunk_bytes_uuid);
  return result.toString();
}

showAlertDialog4(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog5(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog6(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog7(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog8(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog10(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
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

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
