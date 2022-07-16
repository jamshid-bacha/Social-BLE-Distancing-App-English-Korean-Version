import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioCheck extends StatefulWidget {
  @override
  _RadioCheckState createState() => _RadioCheckState();
}

class _RadioCheckState extends State<RadioCheck> {
  // The inital group value
  int _selectedGender = 1;
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Please Select the one Method for Upload Data:'),
        ListTile(
          leading: Radio(
            value: 0,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
                pleasewritefileuploadingmethod(1);
              });
            },
          ),
          title: Text('Real Time'),
        ),
        ListTile(
          leading: Radio(
            value: 1,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
                pleasewritefileuploadingmethod(2);
              });
            },
          ),
          title: Text('Every Five Minutes'),
        ),
        ListTile(
          leading: Radio(
            value: 2,
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
                pleasewritefileuploadingmethod(3);
              });
            },
          ),
          title: Text('Backup (24 hrs)'),
        ),
      ],
    );
  }
}

pleasewritefileuploadingmethod(int text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('fileuploading', text);
  debugPrint(
      "*********************************************************************************************");
  debugPrint(
      "Your File Uploading value ,i.e. ${text} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}
