import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:sensors/sensors.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:ext_storage/ext_storage.dart';
import 'dart:async';
import 'dart:io';

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
  //csvgenerator();
  //csvgenerator("Idiot", "Idiot", 2, "Idiot");
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
  List<List<dynamic>> rows = [];
  // updpating values after 1 sec on screen.
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<double> _userAccelerometerValues;
  //Geroscope Veriable
  List<double> _gyroscopeValues;

  final int _AlarmID = 0;
  void getPermission() async {
    print("getPermission");
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  showoff1() {
    csvgenerator();
    //csvgenerator("Idiot", "Idiot", 2, "Idiot");
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

  /////////////////////////////////////////////////////////
  Future<int> _readIndicator() async {
    String text;
    int indicator;
    try {
      String path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOCUMENTS);
      String fullPath = "$path/Sensors.csv";
      final File file = File(fullPath);
      text = await file.readAsString();
      indicator = 1;
    } catch (e) {
      indicator = 0;
    }
    return indicator;
  }

  void csvgenerator() async {
    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOCUMENTS);
    String file = "$dir";

    var f = await File(file + "/Sensors.csv");
    int dd = await _readIndicator();
    if (dd == 1) {
      if (y == 0) {
        y = 1;
        final csvFile = new File(file + "/Sensors.csv").openRead();
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
          row.add(dat[i][6]);
          row.add(dat[i][7]);
          rows.add(row);
        }
        // String latt = pinLocation.latitude.toString();
        // String longg = pinLocation.longitude.toString();
        // String altt = pinLocation.altitude.toString();
        final List<String> gyroscope =
            _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
        final List<String> accelerometer = _userAccelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            ?.toList();
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String time = DateFormat('Hms').format(now);
        String date = formatter.format(now);
        // String speed = pinLocation.speed.toStringAsFixed(7);
        row.add("$date");
        row.add("$time");
        row.add("${accelerometer[0]}");
        row.add("${accelerometer[1]}");
        row.add("${accelerometer[2]}");
        row.add("${gyroscope[0]}");
        row.add("${gyroscope[1]}");
        row.add("${gyroscope[2]}");
        rows.add(row);

        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
        rows.clear();
      } else {
        final List<String> gyroscope =
            _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
        final List<String> accelerometer = _userAccelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            ?.toList();
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String time = DateFormat('Hms').format(now);
        String date = formatter.format(now);
        // String speed = pinLocation.speed.toStringAsFixed(7);

        List<dynamic> row = [];
        row.add("$date");
        row.add("$time");
        row.add("${accelerometer[0]}");
        row.add("${accelerometer[1]}");
        row.add("${accelerometer[2]}");
        row.add("${gyroscope[0]}");
        row.add("${gyroscope[1]}");
        row.add("${gyroscope[2]}");
        rows.add(row);

        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
        rows.clear();
      }
    } else {
      List<dynamic> row = [];
      row.add("date");
      row.add("time");
      row.add("ax");
      row.add("ay");
      row.add("az");
      row.add("gx");
      row.add("gy");
      row.add("gz");
      rows.add(row);
      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
      rows.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    getPermission();
    super.initState();
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    csvgenerator();
    AndroidAlarmManager.periodic(
        const Duration(seconds: 1), _AlarmID, showoff1);
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
    String fullPath = "$path/Beacons.csv";
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
  String dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print("dir $dir");
  String file = "$dir";

  var f = await File(file + "/Beacons.csv");
  int dd = await _readIndicator();
  if (dd == 1) {
    if (y == 0) {
      y = 1;
      print("**********************************************************");
      print("There is file!");
      print("**********************************************************");
      final csvFile = new File(file + "/Beacons.csv").openRead();
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
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String time = DateFormat('kk:mm:s').format(now);
      String date = formatter.format(now);
      f.writeAsString(
          "$uname,$beaconid_others,$date,$time,$distance,$u_beaconid" + '\n',
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
          "$uname,$beaconid_others,$date,$time,$distance,$u_beaconid" + '\n',
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
