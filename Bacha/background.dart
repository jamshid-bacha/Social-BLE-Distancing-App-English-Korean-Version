import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';

import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:ext_storage/ext_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

int y = 0;
var dio = Dio();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

showoff() {
  csvgenerator("Idiot", "Idiot", 2, "Idiot");
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/ref',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple body'));
  print('alarm done');
}

class _MyAppState extends State<MyApp> {
  final int _AlarmID = 0;
  Location location = Location();

  Map<String, double> currentLocation;

  void getPermission() async {
    print("getPermission");
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permissions =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
  }

  @override
  void initState() {
    // TODO: implement initState
    getPermission();
    location.onLocationChanged.listen((value) {
      setState(() {
        currentLocation = value as Map<String, double>;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AndroidAlarmManager.periodic(const Duration(seconds: 1), _AlarmID, showoff);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

Future<int> _readIndicator() async {
  String text;
  int indicator;
  try {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/GPSData.csv";
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

void csvgenerator(String uname, String beaconid_others, double distance,
    String u_beaconid) async {
  Location location = Location();

  Map<String, double> currentLocation;
  // currentLocation == null
  //     ? CircularProgressIndicator()
  //     : Text("Location:" +
  //         currentLocation["latitude"].toString() +
  //         " " +
  //         currentLocation["longitude"].toString());
  String lat = currentLocation["latitude"].toString();
  print(
      "^^^^^^^^^^^^^^^^^^^^^^^^^^^*************************(((((((((((((())))))))))))))))))@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  print("Latitude: " + lat);

  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";

  var f = await File(file + "/GPSData.csv");
  int dd = await _readIndicator();
  if (dd == 1) {
    if (y == 0) {
      y = 1;
      print("**********************************************************");
      print("There is file!");
      print("**********************************************************");
      final csvFile = new File(file + "/GPSData.csv").openRead();
      var dat = await csvFile
          .transform(utf8.decoder)
          .transform(
            CsvToListConverter(),
          )
          .toList();

      List<List<dynamic>> rows = [];

      List<dynamic> row = [];
      for (int i = 0; i < dat.length; i++) {
        List<dynamic> row = [];
        row.add(dat[i][0]);
        row.add(dat[i][1]);
        row.add(dat[i][2]);
        row.add(dat[i][3]);
        row.add(dat[i][4]);
        row.add(dat[i][5]);

        print(
            "```````````````````````````````````````````````````````````````````````object```````````````````````````````````````````````````````````````````````");
        print(dat[i][0]);
        print(dat[i][1]);
        rows.add(row);
      }
      // for (int i = 0; i < dat.length; i++) {
      //   List<dynamic> row = [];
      //   row.add(dat[i][0]);
      //   row.add(dat[i][1]);
      //   row.add(dat[i][2]);
      //   row.add(dat[i][3]);
      //   row.add(dat[i][4]);
      //   rows.add(row);
      // }
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String time = DateFormat('kk:mm:s').format(now);
      String date = formatter.format(now);
      // row.add(date);
      // row.add(time);
      // row.add(uuid);
      // row.add(distance);
      // rows.add(row);
      // await Future.delayed(Duration(seconds: 10));
      // String csver = const ListToCsvConverter().convert(rows);
      f.writeAsString(
          "$lat,$beaconid_others,$date,$time,$distance,$u_beaconid" + '\n',
          mode: FileMode.append,
          flush: true);
      // for (int i = 0; i < 1000; i++) {}
    } else {
      // final cron = Cron()
      //   ..schedule(Schedule.parse('*/1 * * * * *'), () {
      //     print(DateTime.now());
      //   });
      await Future.delayed(Duration(seconds: 100));
      // List<List<dynamic>> rows = [];

      // List<dynamic> row = [];
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      var time = DateFormat('HH:mm:ss').format(now);
      var date = formatter.format(now);
      // row.add(date);
      // row.add(time);
      // row.add(uuid);
      // row.add(distance);

      // rows.add(row);

      // String csv = const ListToCsvConverter().convert(rows);
      // await Future.delayed(Duration(seconds: 10));
      f.writeAsString(
          "$lat,$beaconid_others,$date,$time,$distance,$u_beaconid" + '\n',
          mode: FileMode.append,
          flush: true);
    }
  } else {
    // List<List<dynamic>> rows = [];

    // List<dynamic> row = [];
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    var time = DateFormat('HH:mm:ss').format(now);
    var date = formatter.format(now);
    // row.add(date);
    // row.add(time);
    // row.add(uuid);
    // row.add(distance);

    // rows.add(row);

    // String csv = const ListToCsvConverter().convert(rows);
    // await Future.delayed(Duration(seconds: 10));
    f.writeAsString(
        "token,beaconid_others,date,time,distance,u_beaconid" + '\n',
        mode: FileMode.append,
        flush: true);
    // for (int i = 0; i < 1000; i++) {}
  }
}
