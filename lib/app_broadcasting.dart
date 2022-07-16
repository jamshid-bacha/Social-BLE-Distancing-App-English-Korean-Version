import 'package:flutter/material.dart';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:uuid/uuid.dart';

//transmitter
Future<void> onPressed() async {
  if (broadcasting) {
    await flutterBeacon.stopBroadcast();
  } else {
    //**************Rather Simple************************************
    String uu = await pleasegetmyuuid();

    //**************Rather Simple************************************

    print("***********************************************************");
    print("Hello, this is uuid being broadcasted: ${uu}");
    print("***********************************************************");
    await flutterBeacon.startBroadcast(BeaconBroadcast(
      proximityUUID: uu,
      major: int.tryParse(majorController.text) ?? 0,
      minor: int.tryParse(minorController.text) ?? 0,
    ));
  }
}

//**************************************************************/
final clearFocus = FocusNode();
bool broadcasting = false;

final regexUUID = RegExp(r'[0-90-90-0]{8}');
final uuidController = TextEditingController(text: '00000006');
final majorController = TextEditingController(text: '0');
final minorController = TextEditingController(text: '0');

@override
void initState() {
  initBroadcastBeacon();
}

initBroadcastBeacon() async {
  await flutterBeacon.initializeScanning;
}

@override
void dispose() {
  clearFocus.dispose();
}

Future<String> getuuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('stringValue');
  return stringValue;
}

Future<String> pleasegetmyuuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('myuuid');
  return stringValue;
}

Future<void> pleasewritemyuuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String txter = await pleasegetmeuuid();
  prefs.setString('pleasemyuuid', txter);
  debugPrint(
      "*********************************************************************************************");
  debugPrint("A new content,i.e. ${txter} has been stored in local storage");
  debugPrint(
      "*********************************************************************************************");
}

Future<String> pleasegetmeuuid() async {
  var uuid = Uuid();
  String varuuid;
  // int _x=2;
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
