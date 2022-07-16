import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue_beacon/flutter_blue_beacon.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:geolocation/geolocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
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
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart';
import 'package:location/location.dart';
import 'package:location_platform_interface/location_platform_interface.dart';

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
  GoogleMapController mapController;

  LocationData pinLocation;
  final IBeacon iBeacon;
  int _integ = 0;

  FlutterBlueBeacon ieacon = FlutterBlueBeacon.instance;
  List<List<dynamic>> rows = List<List<dynamic>>();

  IBeaconCard({@required this.iBeacon});
  // final a = IBeacon.fromScanResult(iBeacon.;

  //get the sensor data and set then to the data types

  @override
  Widget build(BuildContext context) {
    double ax = 0.0, ay = 0.0, az = 0.0;
    double gx = 0.0, gy = 0.0, gz = 0.0;
    Position _currentPosition;
    double lat, long, alti = 0.0, speed = 0.0;

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      ax = event.x;
      ay = event.y;
      az = event.z;
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      gx = event.x;
      gy = event.y;
      gz = event.z;
    });

    Geolocator.getCurrentPosition(forceAndroidLocationManager: true)
        .then((Position position) {
      _currentPosition = position;
      lat = _currentPosition.latitude;
      long = _currentPosition.longitude;
      alti = _currentPosition.altitude;
      speed = _currentPosition.speed;
    }).catchError((e) {
      print(e);
    });

    final a = iBeacon.uuid;
    final b = iBeacon.distance;
    final rssii = iBeacon.rssi;
    var tx = iBeacon.tx;
    var id = iBeacon.id;

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    var time = DateFormat('HH:mm:ss').format(now);
    var date = formatter.format(now);

    print("********************************************************");
    print("Let me know the UUID:");
    print(a);

    /// We require the initializers to run after the loading screen is rendered
    Timer(Duration(seconds: 20), () async {
      String myuuid_bro = await pleasegetmyuuid();
      String myusername_bro = await getmytoken();
      print("Yeah, this line is printed after 3 seconds");
      // var disty=double.parse(b);
      csvgenerator(date, time, myusername_bro, a.toString(), b, myuuid_bro,
          rssii, tx, ax, ay, az, gx, gy, gz, lat, long, alti, speed);
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

void csvgenerator(
    var date,
    var time,
    String uname,
    String beaconid_others,
    double distance,
    String u_beaconid,
    final rssi,
    var tx,
    double ax,
    double ay,
    double az,
    double gx,
    double gy,
    double gz,
    double lat,
    double long,
    double alti,
    double speed) async {
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
        row.add(dat[i][6]);
        row.add(dat[i][7]);
        row.add(dat[i][8]);
        row.add(dat[i][9]);
        row.add(dat[i][10]);
        row.add(dat[i][11]);
        row.add(dat[i][12]);
        row.add(dat[i][13]);
        row.add(dat[i][14]);
        row.add(dat[i][15]);
        row.add(dat[i][16]);
        row.add(dat[i][17]);
        row.add(dat[i][18]);

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

      // row.add(date);
      // row.add(time);
      // row.add(uuid);
      // row.add(distance);
      // rows.add(row);
      // await Future.delayed(Duration(seconds: 10));
      // String csver = const ListToCsvConverter().convert(rows);
      f.writeAsString(
          "$uname,$date,$time,$rssi,$tx,$distance,$lat,$long,$ax,$ay,$az,$gx,$gy,$gz,$alti,$speed,$beaconid_others,$u_beaconid," +
              '\n',
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

      // row.add(date);
      // row.add(time);
      // row.add(uuid);
      // row.add(distance);

      // rows.add(row);

      // String csv = const ListToCsvConverter().convert(rows);
      // await Future.delayed(Duration(seconds: 10));
      if (!(beaconid_others.toString() == "null" ||
          date.toString() == "null" ||
          time.toString() == "null" ||
          distance.toString() == "null" ||
          u_beaconid.toString() == "null" ||
          rssi.toString() == "null" ||
          ax.toString() == "null" ||
          ay.toString() == "null" ||
          az.toString() == "null" ||
          gx.toString() == "null" ||
          gy.toString() == "null" ||
          gz.toString() == "null" ||
          lat.toString() == "null" ||
          long.toString() == "null" ||
          alti.toString() == "null" ||
          speed.toString() == "null" ||
          tx.toString() == "null")) {
        f.writeAsString(
            "$uname,$date,$time,$rssi,$tx,$distance,$lat,$long,$ax,$ay,$az,$gx,$gy,$gz,$alti,$speed,$beaconid_others,$u_beaconid," +
                '\n',
            mode: FileMode.append,
            flush: true);
      }
    }
  } else {
    // List<List<dynamic>> rows = [];

    // List<dynamic> row = [];

    // row.add(date);
    // row.add(time);
    // row.add(uuid);
    // row.add(distance);

    // rows.add(row);

    // String csv = const ListToCsvConverter().convert(rows);
    // await Future.delayed(Duration(seconds: 10));
    f.writeAsString(
        "token,date,time,rssi,tx,distance,lat,long,ax,ay,az,gx,gy,gz,altitude,speed,beaconid_others,u_beaconid" +
            '\n',
        mode: FileMode.append,
        flush: true);
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
