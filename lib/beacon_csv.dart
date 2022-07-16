import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_beacon/flutter_blue_beacon.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'main.g.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:csv/csv.dart';
import 'dart:convert';

Timer timer;

class DaterAdapter extends TypeAdapter<Dater> {
  @override
  final typeId = 0;

  @override
  Dater read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dater(
      longg: fields[0] as String,
      latt: fields[1] as String,
      altt: fields[2] as String,
      indexer: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Dater obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.longg)
      ..writeByte(1)
      ..write(obj.latt)
      ..writeByte(2)
      ..write(obj.altt)
      ..writeByte(3)
      ..write(obj.indexer);
  }
}

final imgUrl =
    "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/csv/dummy.csv";
int y = 0;
var dio = Dio();

class IBeaconCard extends StatelessWidget {
  final IBeacon iBeacon;
  int _integ = 0;

  FlutterBlueBeacon ieacon = FlutterBlueBeacon.instance;
  List<List<dynamic>> rows = List<List<dynamic>>();

  IBeaconCard({@required this.iBeacon});
  // final a = IBeacon.fromScanResult(iBeacon.;
  @override
  Widget build(BuildContext context) {
    final a = iBeacon.uuid;
    final b = iBeacon.distance;
    print("********************************************************");
    print("Let me know the UUID:");
    print(a);

    /// We require the initializers to run after the loading screen is rendered
    Timer(Duration(seconds: 20), () async {
      String myuuid_bro = await getmyuuid();
      String myusername_bro = await getmytoken();
      print("Yeah, this line is printed after 3 seconds");
      // var disty=double.parse(b);
      csvgenerator(myusername_bro, a.toString(), b, myuuid_bro);
    });
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t)
    // async {
    //   WidgetsFlutterBinding.ensureInitialized();
    //   final appDocumentDir = await getApplicationDocumentsDirectory();
    //   print(appDocumentDir.path);
    //   Hive
    //     ..init(appDocumentDir.path)
    //     ..registerAdapter(DaterAdapter());
    //   // await updatetable(a.toString(),b.toString(),"123",1);
    //   print("Done!!");
    //
    // }
    // );

    print("***************************************************************");
    //********************************************************************************

    //********************************************************************************
    //print(a);
    return Card(
      child: Column(
        children: <Widget>[
          //Text("iBeacon"),

          // Text("uuid: ${iBeacon.uuid}"),
          // // Text("major: ${iBeacon.major}"),
          // // Text("minor: ${iBeacon.minor}"),
          // Text("tx: ${iBeacon.tx}"),
          // Text("rssi: ${iBeacon.rssi}"),
          // Text("distance: ${iBeacon.distance}"),
        ],
      ),
    );
  }
}

class EddystoneUIDCard extends StatelessWidget {
  final EddystoneUID eddystoneUID;

  EddystoneUIDCard({@required this.eddystoneUID});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text("EddystoneUID"),
          Text("beaconId: ${eddystoneUID.beaconId}"),
          Text("namespaceId: ${eddystoneUID.namespaceId}"),
          Text("tx: ${eddystoneUID.tx}"),
          Text("rssi: ${eddystoneUID.rssi}"),
          Text("distance: ${eddystoneUID.distance}"),
        ],
      ),
    );
  }
}

class EddystoneEIDCard extends StatelessWidget {
  final EddystoneEID eddystoneEID;

  EddystoneEIDCard({@required this.eddystoneEID});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text("EddystoneEID"),
          Text("ephemeralId: ${eddystoneEID.ephemeralId}"),
          Text("tx: ${eddystoneEID.tx}"),
          Text("rssi: ${eddystoneEID.rssi}"),
          Text("distance: ${eddystoneEID.distance}"),
        ],
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
      if (uname == null ||
          date == null ||
          time == null ||
          beaconid_others == null ||
          distance == null ||
          u_beaconid == null) {
        print("FURQAN furqan");
      } else {
        f.writeAsString(
            "$uname,$beaconid_others,$date,$time,$distance,$u_beaconid" + '\n',
            mode: FileMode.append,
            flush: false);
      }
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
      var time = DateFormat('Hms').format(now);
      var date = formatter.format(now);
      // row.add(date);
      // row.add(time);
      // row.add(uuid);
      // row.add(distance);

      // rows.add(row);

      // String csv = const ListToCsvConverter().convert(rows);
      // await Future.delayed(Duration(seconds: 10));
      if (uname == null ||
          date == null ||
          time == null ||
          beaconid_others == null ||
          distance == null ||
          u_beaconid == null) {
        print("FURQAN furqan");
      } else {
        f.writeAsString(
            "$uname,$beaconid_others,$date,$time,$distance,$u_beaconid" + '\n',
            mode: FileMode.append,
            flush: false);
      }
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
        "uname,beaconid_others,date,time,distance,u_beaconid" + '\n',
        mode: FileMode.append,
        flush: false);
    // for (int i = 0; i < 1000; i++) {}
  }
}

Future<void> updatetable(String s, String t, String u, int i) async {
  var box = await Hive.openBox('bTdat');
  Dater dater = Dater(longg: s, latt: t, altt: u, indexer: i);
  await box.put('bTdat${i}', dater);
  print('bTdat${i}:Done!!!!!!!!!!!!!!!!!!!!!!!!');
}

Future<String> getmyuuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('myuuid');
  return stringValue;
}

Future<String> getmytoken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('tokyboy');
  return stringValue;
}

Future<String> pleasegetmyuuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('pleasemyuuid');
  return stringValue;
}
