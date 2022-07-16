import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KRadioCheck extends StatefulWidget {
  @override
  _KRadioCheckState createState() => _KRadioCheckState();
}

class _KRadioCheckState extends State<KRadioCheck> {
  // The inital group value
  int _selectedGender = 1;
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('데이터 업로드 방법 중 하나를 선택하십시오.'),
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
          title: Text('실시간'),
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
          title: Text('5 분마다'),
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
          title: Text('백업 (24 시간)'),
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
