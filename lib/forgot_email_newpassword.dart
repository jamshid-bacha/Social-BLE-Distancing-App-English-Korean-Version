import 'package:flutter/material.dart';
import 'package:where/forgot_email.dart';
import 'package:where/main.dart';
import 'package:where/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Email {
  final String email;

  Email(this.email);
}

class ResetForm extends StatefulWidget {
  final String email;

  ResetForm({Key key, this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ResetFormState();
  }
}

class _ResetFormState extends State<ResetForm> {
  final _minpad = 5.0;
  final myController_pass = TextEditingController();
  final myController_newpass = TextEditingController();

  updatepassword(email, newpassword, confirmnewpassword) async {
    var url = Uri.http('52.74.221.135:5000', '/forgetpass');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          "email": email,
          "new_password": newpassword,
          "confirm_password": confirmnewpassword
        }));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['token'];
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
                      "Reset Password",
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
                      controller: myController_pass,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: 'Enter New Password',
                          hintText: 'only characters and numbers are allowed',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                    child: TextField(
                      controller: myController_newpass,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          labelText: 'Enter New Password Again',
                          hintText: 'only characters and numbers are allowed',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                // Padding(
                //     padding:EdgeInsets.only(top:_minpad,bottom: _minpad),
                //
                //     child:Row(children: <Widget>[
                //
                //       Expanded(
                //         child: Padding(
                //             padding: EdgeInsets.only(top:_minpad,bottom: _minpad),
                //             child:TextField(
                //               keyboardType: TextInputType.phone,
                //               decoration: InputDecoration(
                //                   labelText: 'Phone Number',
                //                   hintText: '(+Country Code)(Phone Number))',
                //                   border: OutlineInputBorder(
                //                       borderRadius: BorderRadius.circular(5.0))),
                //             )),),
                //
                //       Container(width: _minpad*5,),
                //       Expanded(
                //           child:DropdownButton<String>(
                //               hint: Text('Category'),
                //               items:_cat.map((String value){
                //                 return DropdownMenuItem<String>(
                //                   value:value,
                //                   child:Text(value),
                //                 );
                //               }
                //               ).toList(),
                //               value:_currentCat,
                //               onChanged: (String newValueSelected)
                //               {
                //                 _onDroDownItemSelected(newValueSelected);
                //               }
                //
                //           ))
                //     ],)),
                // Padding(
                //     padding: EdgeInsets.only(top:_minpad,bottom: _minpad),
                //     child:TextField(
                //       keyboardType: TextInputType.name,
                //       decoration: InputDecoration(
                //           labelText: 'New Password',
                //           hintText:'only characters and numbers are allowed',
                //           border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(5.0)
                //           )
                //       ),
                //     )),

                Padding(
                  padding: EdgeInsets.only(top: _minpad, bottom: _minpad),
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Reset'),
                        onPressed: () async {
                          debugPrint(
                              "**************************************************************");
                          debugPrint(widget.email);
                          final login_result = await updatepassword(
                              widget.email,
                              myController_pass.text,
                              myController_newpass.text);
                          print(
                              "Update password result: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::" +
                                  login_result.toString());
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginForm();
                          }));
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

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/reset_fig.png');
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
