import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'About_this_app.dart';
import 'Korean_Language/About_this_app.dart';
import 'Korean_Language/Manage_Contact_Tracing.dart';
import 'Korean_Language/SeetingScreen.dart';
import 'Language.dart';
import 'Manage_Contact_Tracing.dart';
import 'SeetingScreen.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'beacon_csv.dart';
import 'package:flutter_blue_beacon/flutter_blue_beacon.dart';
import 'app_broadcasting.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:cron/cron.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

final imgUrl =
    "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/csv/dummy.csv";

var dio = Dio();
int i = 0;
int y = 0;
int check = 0;
int korean = 0;
int uploading_method = 0;
int retentor = 0;
String uuIdier = "";
int check_internet_connection = 0;
int header = 0;
int rows_length = 0;
int delete_row = 0;
int blue_check = 0;
int header1 = 0;
int delete_row1 = 0;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  runApp(new MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
    routes: <String, WidgetBuilder>{
      '/MyApp': (BuildContext context) => new MyApp(),
    },
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCR_Lab_Plus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'CCR_Lab_Plus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> enableBT() async {
    BluetoothEnable.enableBluetooth.then((value) {});
  }

  void bluetoothnotification() {
    BluetoothState state = BluetoothState.unknown;
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });

    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/my_splash',
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
    if (state != BluetoothState.on) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 9,
              channelKey: 'basic_channel',
              title: 'Please Turn ON Bluetooth',
              body: 'For Contact Tracing needs to ON Bluetooth'));
    }
  }

  var cron = new Cron();
  //Transmitter
  final int _AlarmID = 0;
  final int _AlarmID1 = 1;

  FlutterBlueBeacon flutterBlueBeacon = FlutterBlueBeacon.instance;
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<int, Beacon> beacons = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  String g = "";
  String time1 = "";
  List<List<dynamic>> rows = List<List<dynamic>>();

  void getPermission() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permissions =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
  }

  /////////////////////////////////////////////////////////
  Future<int> _readIndicator() async {
    String text;
    int indicator;
    try {
      String path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOCUMENTS);
      String fullPath = "$path/Sensor_Data1.csv";
      final File file = File(fullPath);
      text = await file.readAsString();
      indicator = 1;
    } catch (e) {
      indicator = 0;
    }
    return indicator;
  }

  delay() {
    Future.delayed(Duration(seconds: 10));
  }

  void csvgenerator(String usey) async {
    String myusername_bro = await getmyusername();
    usey = myusername_bro;
    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOCUMENTS);
    String file = "$dir";

    var f = await File(file + "/Sensor_Data1.csv");
    int dd = await _readIndicator();
    if (dd == 1) {
      if (y == 0) {
        y = 1;
        final csvFile = new File(file + "/Sensor_Data1.csv").openRead();
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
          rows.add(row);
          if (i == 1) {
            rows.clear();
          }
        }
        String latt = pinLocation.latitude.toString();
        String longg = pinLocation.longitude.toString();
        String altt = pinLocation.altitude.toString();
        final List<String> gyroscope =
            _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
        final List<String> accelerometer = _accelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            ?.toList();
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String time = DateFormat('Hms').format(now);
        String date = formatter.format(now);
        String speed = pinLocation.speed.toStringAsFixed(7);

        if (time != time1) {
          List<dynamic> row = [];
          row.add("$usey");
          row.add("$date");
          row.add("$time");
          row.add("$latt");
          row.add("$longg");
          row.add("$altt");
          row.add("$speed");
          row.add("${accelerometer[0]}");
          row.add("${accelerometer[1]}");
          row.add("${accelerometer[2]}");
          row.add("${gyroscope[0]}");
          row.add("${gyroscope[1]}");
          row.add("${gyroscope[2]}");
          rows.add(row);
          if (row[0] == null ||
              row[1] == null ||
              row[2] == null ||
              row[3] == null ||
              row[4] == null ||
              row[5] == null ||
              row[6] == null ||
              row[7] == null ||
              row[8] == null ||
              row[9] == null ||
              row[10] == null ||
              row[11] == null ||
              row[12] == null ||
              row[0] == "" ||
              row[1] == "" ||
              row[2] == "" ||
              row[3] == "" ||
              row[4] == "" ||
              row[5] == "" ||
              row[6] == "" ||
              row[7] == "" ||
              row[8] == "" ||
              row[9] == "" ||
              row[10] == "" ||
              row[11] == "" ||
              row[12] == "" ||
              row[0] == "uname" ||
              row[1] == "date" ||
              row[2] == "time" ||
              row[3] == "lat" ||
              row[4] == "long" ||
              row[5] == "altituide" ||
              row[6] == "velocity" ||
              row[7] == "ax" ||
              row[8] == "ay" ||
              row[9] == "az" ||
              row[10] == "gx" ||
              row[11] == "gy" ||
              row[12] == "gz") {
            rows.clear();
          } else {
            if (delete_row == 0) {
              rows.clear();
              delete_row = 1;
            } else {
              String csv = const ListToCsvConverter().convert(rows);
              f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
              rows.clear();
            }
          }
          time1 = time;
        }
      } else {
        String latt = pinLocation.latitude.toString();
        String longg = pinLocation.longitude.toString();
        String altt = pinLocation.altitude.toString();
        final List<String> gyroscope =
            _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
        final List<String> accelerometer = _accelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            ?.toList();
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String time = DateFormat('Hms').format(now);
        String date = formatter.format(now);
        String speed = pinLocation.speed.toStringAsFixed(7);

        if (time1 != time) {
          List<dynamic> row = [];
          row.add("$usey");
          row.add("$date");
          row.add("$time");
          row.add("$latt");
          row.add("$longg");
          row.add("$altt");
          row.add("$speed");
          row.add("${accelerometer[0]}");
          row.add("${accelerometer[1]}");
          row.add("${accelerometer[2]}");
          row.add("${gyroscope[0]}");
          row.add("${gyroscope[1]}");
          row.add("${gyroscope[2]}");
          rows.add(row);
          if (row[0] == null ||
              row[1] == null ||
              row[2] == null ||
              row[3] == null ||
              row[4] == null ||
              row[5] == null ||
              row[6] == null ||
              row[7] == null ||
              row[8] == null ||
              row[9] == null ||
              row[10] == null ||
              row[11] == null ||
              row[12] == null ||
              row[0] == "" ||
              row[1] == "" ||
              row[2] == "" ||
              row[3] == "" ||
              row[4] == "" ||
              row[5] == "" ||
              row[6] == "" ||
              row[7] == "" ||
              row[8] == "" ||
              row[9] == "" ||
              row[10] == "" ||
              row[11] == "" ||
              row[12] == "" ||
              row[0] == "uname" ||
              row[1] == "date" ||
              row[2] == "time" ||
              row[3] == "lat" ||
              row[4] == "long" ||
              row[5] == "altituide" ||
              row[6] == "velocity" ||
              row[7] == "ax" ||
              row[8] == "ay" ||
              row[9] == "az" ||
              row[10] == "gx" ||
              row[11] == "gy" ||
              row[12] == "gz") {
            rows.clear();
          } else {
            if (delete_row == 0) {
              rows.clear();
              delete_row = 1;
            } else {
              String csv = const ListToCsvConverter().convert(rows);
              f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
              rows.clear();
            }
          }
          time1 = time;
        }
      }
    } else if (dd == 0) {
      if (header == 0) {
        header = 1;
        List<dynamic> row = [];
        row.add("uname");
        row.add("date");
        row.add("time");
        row.add("lat");
        row.add("long");
        row.add("altituide");
        row.add("velocity");
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
  }

  /////////////////////////////////////////////////////////
  Future<int> _readIndicator1() async {
    String text;
    int indicator;
    try {
      String path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOCUMENTS);
      String fullPath = "$path/Sensor.csv";
      final File file = File(fullPath);
      text = await file.readAsString();
      indicator = 1;
    } catch (e) {
      indicator = 0;
    }
    return indicator;
  }

  void csvsensordata(String usey) async {
    String myusername_bro = await getmyusername();
    usey = myusername_bro;
    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOCUMENTS);
    String file = "$dir";

    var f = await File(file + "/Sensor.csv");
    int dd = await _readIndicator1();
    if (dd == 1) {
      if (y == 0) {
        y = 1;
        final csvFile = new File(file + "/Sensor.csv").openRead();
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
          rows.add(row);
          if (i == 1) {
            rows.clear();
          }
        }
        final List<String> gyroscope =
            _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
        final List<String> accelerometer = _accelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            ?.toList();
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String speed = pinLocation.speed.toStringAsFixed(7);
        String time = DateFormat('Hms').format(now);
        String date = formatter.format(now);
        row.add("$usey");
        row.add("$date");
        row.add("$time");
        row.add("${accelerometer[0]}");
        row.add("${accelerometer[1]}");
        row.add("${accelerometer[2]}");
        row.add("${gyroscope[0]}");
        row.add("${gyroscope[1]}");
        row.add("${gyroscope[2]}");
        row.add("$speed");
        rows.add(row);
        if (row[0] == null ||
            row[1] == null ||
            row[2] == null ||
            row[3] == null ||
            row[4] == null ||
            row[5] == null ||
            row[6] == null ||
            row[7] == null ||
            row[8] == null ||
            row[9] == null ||
            row[0] == "" ||
            row[1] == "" ||
            row[2] == "" ||
            row[3] == "" ||
            row[4] == "" ||
            row[5] == "" ||
            row[6] == "" ||
            row[7] == "" ||
            row[8] == "" ||
            row[9] == "" ||
            row[0] == "uname" ||
            row[1] == "date" ||
            row[2] == "time" ||
            row[3] == "ax" ||
            row[4] == "ay" ||
            row[5] == "az" ||
            row[6] == "gx" ||
            row[7] == "gy" ||
            row[8] == "gz" ||
            row[9] == "speed") {
          rows.clear();
        } else {
          if (delete_row1 == 0) {
            rows.clear();
            delete_row1 = 1;
          } else {
            String csv = const ListToCsvConverter().convert(rows);
            f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
            rows.clear();
          }
        }
      } else {
        final List<String> gyroscope =
            _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
        final List<String> accelerometer = _accelerometerValues
            ?.map((double v) => v.toStringAsFixed(1))
            ?.toList();
        String speed = pinLocation.speed.toStringAsFixed(7);
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String time = DateFormat('Hms').format(now);
        String date = formatter.format(now);

        List<dynamic> row = [];
        row.add("$usey");
        row.add("$date");
        row.add("$time");
        row.add("${accelerometer[0]}");
        row.add("${accelerometer[1]}");
        row.add("${accelerometer[2]}");
        row.add("${gyroscope[0]}");
        row.add("${gyroscope[1]}");
        row.add("${gyroscope[2]}");
        row.add("$speed");
        rows.add(row);
        if (row[0] == null ||
            row[1] == null ||
            row[2] == null ||
            row[3] == null ||
            row[4] == null ||
            row[5] == null ||
            row[6] == null ||
            row[7] == null ||
            row[8] == null ||
            row[9] == null ||
            row[0] == "" ||
            row[1] == "" ||
            row[2] == "" ||
            row[3] == "" ||
            row[4] == "" ||
            row[5] == "" ||
            row[6] == "" ||
            row[7] == "" ||
            row[8] == "" ||
            row[9] == "" ||
            row[0] == "uname" ||
            row[1] == "date" ||
            row[2] == "time" ||
            row[3] == "ax" ||
            row[4] == "ay" ||
            row[5] == "az" ||
            row[6] == "gx" ||
            row[7] == "gy" ||
            row[8] == "gz" ||
            row[9] == "speed") {
          rows.clear();
        } else {
          if (delete_row1 == 0) {
            rows.clear();
            delete_row1 = 1;
          } else {
            String csv = const ListToCsvConverter().convert(rows);
            f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
            rows.clear();
          }
        }
      }
    } else if (dd == 0) {
      if (header1 == 0) {
        header1 = 1;
        List<dynamic> row = [];
        row.add("uname");
        row.add("date");
        row.add("time");
        row.add("ax");
        row.add("ay");
        row.add("az");
        row.add("gx");
        row.add("gy");
        row.add("gz");
        row.add("speed");
        rows.add(row);
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv + '\n', mode: FileMode.append, flush: false);
        rows.clear();
      }
    }
  }

  GoogleMapController mapController;
  Location location = new Location();

  LocationData pinLocation;
  @override
  LatLng _initialLocation = LatLng(37.42796133588664, -122.885740655967);
//  Map<String, double> currentLocation;

  List<double> _accelerometerValues;

  // updpating values after 1 sec on screen.
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  //Geroscope Veriable
  List<double> _gyroscopeValues;

  // ignore: cancel_subscriptions

  StreamSubscription<LocationData> locationSubscription;
  // speedometer updation in real time UI
  GlobalKey<KdGaugeViewState> key = GlobalKey<KdGaugeViewState>();

// speedo meter values
  int start = 0;
  int end = 240;
  double _lowerValue = 20.0;
  double _upperValue = 40.0;
  int counter = 0;

// Jo bhi location update ho rhi hogi google map camera view controller vha set kr rha hoga.
//
  void wasay() {
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        pinLocation = currentLocation;
      });
    });
  }

  void _onMapCreated(GoogleMapController _cntrLoc) async {
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        pinLocation = currentLocation;
      });
    });
  }

  // there is satellite view or normal view in order to save internet
  MapType _currentMapType = MapType.normal;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  _clearAllBeacons() {
    setState(() {
      beacons = Map<int, Beacon>();
    });
  }

  _startScan() {
    _scanSubscription = flutterBlueBeacon
        .scan(timeout: const Duration(seconds: 20))
        .listen((beacon) {
      setState(() {
        beacons[beacon.hash] = beacon;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _buildScanResultTiles() {
    return beacons.values.map<Widget>((b) {
      if (b is IBeacon) {
        return IBeaconCard(iBeacon: b);
      }
      if (b is EddystoneUID) {
        return EddystoneUIDCard(eddystoneUID: b);
      }
      if (b is EddystoneEID) {
        return EddystoneEIDCard(eddystoneEID: b);
      }
      return Card();
    }).toList();
  }

  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
        ),
        trailing: new IconButton(
          icon: Icon(
            Icons.bluetooth,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              enableBT();
            });
          },
        ),
      ),
    );
  }

  _buildAlertTile2() {
    return new Container(
      color: Colors.blueAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
        ),
        trailing: new Icon(
          Icons.check,
        ),
      ),
    );
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

//we are initializing state of Acceleroscope and Gyroscope values
  Timer timer;

  @override
  void initState() {
    // FlutterBackgroundService().sendData({"action": "setAsForeground"});
    // FlutterBackgroundService().sendData({"action": "setAsBackground"});
    // cron.schedule(new Schedule.parse('*/2 * * * *'), () async {
    //   bluetooth_on_off();
    // });
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/my_splash',
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
    cron.schedule(new Schedule.parse('*/5 * * * *'), () async {
      backup();
    });

    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => backup());
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
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    // _streamSubscriptions
    //     .add(accelerometerEvents.listen((AccelerometerEvent event) {
    //   setState(() {
    //      = <double>[event.x, event.y, event.z];
    //   });
    // }));
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
    runInitTasks();
  }

  backup() async {
    int check_internet_connection = 0;
    while (check_internet_connection == 0) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        dataupload();
        btupload();
        check_internet_connection = 1;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        dataupload();
        btupload();
        check_internet_connection = 1;
      }
    }
  }

  btupload() async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    String fullPath = "$path/Beacons.csv";
    File file = File(fullPath);
    bt_data_upload(fullPath);
  }

  dataupload() async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOCUMENTS);
    String fullPath = "$path/Sensor_Data1.csv";
    File file = File(fullPath);
    gps_data_upload(fullPath);
  }

  Future runInitTasks() async {
    String tellme = await session_maintainer();
    int tellme2 = await reading_korean();
    if (tellme != null) {
      if (tellme2 == 0) {
        check = 1;
      }
      if (tellme2 == 1) {
        check = 2;
        korean = 1;
      }
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return LanguageScreen();
      // }));
      check = 1;
    }
  }

  bluetooth_on_off() {
    if (state != BluetoothState.on) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 9,
              channelKey: 'basic_channel',
              title: 'Please Turn ON Bluetooth',
              body: 'For Contact Tracing needs to ON Bluetooth'));
    }
  }

  @override
  Widget build(BuildContext context) {
    AndroidAlarmManager.periodic(
        const Duration(minutes: 1), _AlarmID, bluetoothnotification);
    if (check == 0) {
      return Scaffold(
        backgroundColor: Colors.pink[50],
        body: new InkWell(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Container(
                decoration: BoxDecoration(color: Colors.black),
              ),
              new Container(
                child: Image.asset('images/background_Image.png',
                    fit: BoxFit.cover),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    flex: 3,
                    child: new Container(
                        child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                      ],
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /// Loader Animation Widget
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        Text('Please Wait'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (korean == 1) {
      onPressed();
      _startScan();
      wasay();
      var tiles = new List<Widget>();
      if (state != BluetoothState.on) {
        tiles.add(_buildAlertTile());
        if (blue_check == 0) {
          blue_check = 1;
          bluetooth_on_off();
        }
      }

      tiles.addAll(_buildScanResultTiles());
      final TextStyle textLabel = new TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );
      final TextStyle textData = new TextStyle(
        fontSize: 20,
        color: Colors.red[700],
        fontWeight: FontWeight.bold,
      );
      i = 1;
      final ThemeData somTheme = new ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.red,
          backgroundColor: Colors.grey);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[200],
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  // do something
                },
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.upload_file),
                        title: Text('수동 데이터 업로드'),
                      ),
                      value: "/dataupload"),
                  const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.bluetooth),
                        title: Text('수동 데이터 업로드'),
                      ),
                      value: "/btchecky"),
                ],
                onSelected: (value) async {
                  if (value == '/dataupload') {
                    String path =
                        await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);
                    String fullPath = "$path/Beacons.csv";
                    File file = File(fullPath);
                    bt_data_upload(fullPath);
                  } else if (value == '/logout') {
                  } else if (value == '/btchecky') {
                    enableBT();
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/appbackground.jfif"),
                  fit: BoxFit.cover,
                ),
              ),
              //  color: Colors.white,
              child: Column(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        (isScanning)
                            ? _buildProgressBarTile()
                            : new Container(),
                        new ListView(
                          children: tiles,
                        )
                      ],
                    ),
                  ),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 1,
                            ),
                            Container(
                              child: new Image.asset(
                                'images/check-circle.gif',
                                width: 80,
                                height: 80,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            Container(
                              child: Text("앱이 활성화되어 있고 \n         스캐닝",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],

                                color: Colors.teal[200],
                                //  color: Color.fromRGBO(0, 100, 51, 2),
                              ),
                              child: new Image.asset(
                                'images/3856337.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  '내 상태 확인',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  String mytoken_bro = await getmytoken();
                                  String my_username_bro =
                                      await getmyusername();

                                  // await manual_check_bt_status2(mytoken_bro);

                                  String iden = await manual_check_bt_status(
                                      my_username_bro);
                                  if (iden == '1') {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildKPopupDialog(context));
                                    AwesomeNotifications().createNotification(
                                        content: NotificationContent(
                                            id: 10,
                                            channelKey: 'basic_channel',
                                            title: '경보!',
                                            body: 'COVID-19의 위험이 있습니다'));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildKPDialog(context));
                                    AwesomeNotifications().createNotification(
                                        content: NotificationContent(
                                            id: 9,
                                            channelKey: 'basic_channel',
                                            title: '당신은 안전합니다.',
                                            body: '행복하고 안전하게'));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],

                                color: Colors.cyan[200],
                                //  color: Color.fromRGBO(0, 100, 51, 2),
                              ),
                              child: new Image.asset(
                                'images/contact-tracing.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  '연락처 추적 관리',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new KManageContact(),
                                        fullscreenDialog: true,
                                      ));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("$result"),
                                    duration: Duration(seconds: 3),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.deepOrange[100],
                              ),
                              child: new Image.asset(
                                'images/setting.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  '환경',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new KLanguageScreen(),
                                        fullscreenDialog: true,
                                      ));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("$result"),
                                    duration: Duration(seconds: 3),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],

                                color: Colors.indigo[300],
                                //  color: Color.fromRGBO(0, 100, 51, 2),
                              ),
                              child: new Image.asset(
                                'images/smartphone.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  '이 앱에 대해',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new KAboutthisapp(),
                                        fullscreenDialog: true,
                                      ));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("$result"),
                                    duration: Duration(seconds: 3),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ], //<widget>[]
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ), //Column
                  ) //Padding
                      ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (check == 1) {
      onPressed();
      _startScan();
      wasay();
      if (pinLocation != null) {
        csvgenerator("Hello");
      }
      csvsensordata("Hello");
      // uploading_type();
      var tiles = new List<Widget>();
      if (state != BluetoothState.on) {
        tiles.add(_buildAlertTile());
        if (blue_check == 0) {
          blue_check = 1;
          bluetooth_on_off();
        }
      } else {
        tiles.add(_buildAlertTile2());
      }

      tiles.addAll(_buildScanResultTiles());

      final TextStyle textLabel = new TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );
      final TextStyle textData = new TextStyle(
        fontSize: 20,
        color: Colors.red[700],
        fontWeight: FontWeight.bold,
      );

      i = 1;
      dynamic _x = 1.0;
      final ThemeData somTheme = new ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.red,
          backgroundColor: Colors.grey);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue[200],
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.bluetooth),
                        title: Text('Manual Data Upload'),
                      ),
                      value: "/dataupload"),
                  const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.gps_fixed),
                        title: Text('GPS Data Upload'),
                      ),
                      value: "/dataupload2"),
                ],
                onSelected: (value) async {
                  if (value == '/dataupload') {
                    String path =
                        await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);

                    String fullPath = "$path/Beacons.csv";
                    File file = File(fullPath);

                    bt_data_upload(fullPath);
                  } else if (value == '/dataupload2') {
                    String path =
                        await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOCUMENTS);
                    String fullPath = "$path/Sensor_Data1.csv";
                    File file = File(fullPath);
                    gps_data_upload(fullPath);
                  } else if (value == '/logout') {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) {
                      return new LoginForm();
                    }));
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/appbackground.jfif"),
                  fit: BoxFit.cover,
                ),
              ),
              //  color: Colors.white,
              child: Column(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        (isScanning)
                            ? _buildProgressBarTile()
                            : new Container(),
                        new ListView(
                          children: tiles,
                        )
                      ],
                    ),
                  ),
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 1,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],

                                color: Colors.teal[200],
                                //  color: Color.fromRGBO(0, 100, 51, 2),
                              ),
                              child: new Image.asset(
                                'images/3856337.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  'Check my status',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  String mytoken_bro = await getmytoken();
                                  String my_usernamer = await getmyusername();

                                  // await manual_check_bt_status2(mytoken_bro);

                                  String iden = await manual_check_bt_status(
                                      my_usernamer);
                                  if (iden == '1') {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(context));
                                    AwesomeNotifications().createNotification(
                                        content: NotificationContent(
                                            id: 10,
                                            channelKey: 'basic_channel',
                                            title: 'Alert!',
                                            body:
                                                'You are at risk of COVID-19'));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPDialog(context));
                                    AwesomeNotifications().createNotification(
                                        content: NotificationContent(
                                            id: 9,
                                            channelKey: 'basic_channel',
                                            title: 'You are safe.',
                                            body: 'Stay Happy, Stay Safe'));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],

                                color: Colors.cyan[200],
                                //  color: Color.fromRGBO(0, 100, 51, 2),
                              ),
                              child: new Image.asset(
                                'images/contact-tracing.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  'Manage contact tracing',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new ManageContact(),
                                        fullscreenDialog: true,
                                      ));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("$result"),
                                    duration: Duration(seconds: 3),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],

                                color: Colors.deepOrange[100],
                                //  color: Color.fromRGBO(0, 100, 51, 2),
                              ),
                              child: new Image.asset(
                                'images/setting.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  'Setting',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new SettingScreen(),
                                        fullscreenDialog: true,
                                      ));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("$result"),
                                    duration: Duration(seconds: 3),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],

                                color: Colors.indigo[300],
                                //  color: Color.fromRGBO(0, 100, 51, 2),
                              ),
                              child: new Image.asset(
                                'images/smartphone.png',
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                              ),
                            ),

                            ///////////////////////////////////////////
                            Container(
                              margin: EdgeInsets.all(0),
                              width: 240,
                              height: 75,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius:
                                        2.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        2.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      4.0, // horizontal, move right 10
                                      4.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                color: Colors.blue[100],
                              ),
                              child: FlatButton(
                                child: Text(
                                  'About this app',
                                  style: TextStyle(
                                      fontFamily: 'Courier New',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new Aboutthisapp(),
                                        fullscreenDialog: true,
                                      ));

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("$result"),
                                    duration: Duration(seconds: 3),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ], //<widget>[]
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ), //Column
                  ) //Padding
                      ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

Future<void> bt_data_upload(path) async {
  var postUri = Uri.parse('http://52.74.221.135:5000/beacon_data');

  http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

  http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('beaconcsv', path);

  request.files.add(multipartFile);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    deleteBTFile();
  }
}

Future<void> gps_data_upload(path) async {
  var postUri = Uri.parse('http://52.74.221.135:5000/upload_sensor');

  http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

  http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('sensorCsv', path);

  request.files.add(multipartFile);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    deleteFile();
    delete_row = 0;
    header = 0;
  }
}

Future<void> manual_check_bt_status2(String usernamebro) async {
  final response = await http
      .get(Uri.parse('http://52.74.221.135:5000/check_me/${usernamebro}'));
  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body) as List;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<String> manual_check_bt_status(String usernamebro) async {
  var getUri = Uri.parse('http://52.74.221.135:5000/check_me/${usernamebro}');

  http.MultipartRequest request = new http.MultipartRequest("GET", getUri);

  http.StreamedResponse response = await request.send();

  var responsibility = await response.stream.bytesToString();
  if (responsibility == '"Yes"') {
    return '1';
  } else if (responsibility == '"No"') {
    return '0';
  }
}

Future<void> write_response_from_bt_manual_check(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('btManualValue', text);
}

Future<String> getmyusername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('myusername');
  return stringValue;
}

removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("pleasemyuuid");
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('COVID-19 Alert'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("You are in Contact. Go for COVID-19 Testing!"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}

Widget _buildPDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('No Contact Found!'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Stay Happy and Stay Safe"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}

Future<int> _sessionmaintainer() async {
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

Future<String> session_maintainer() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('tokyboy');
  return stringValue;
}

Future<int> reading_korean() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  int stringValue = prefs.getInt('korean');
  return stringValue;
}

Future<int> fileuploading() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  int stringValue = prefs.getInt('fileuploading');
  return stringValue;
}

Widget _buildKPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('코로나 19 경보'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("연락 중입니다. COVID-19 테스트를 시작하십시오!"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('닫기'),
      ),
    ],
  );
}

Widget _buildKPDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('연락처가 없습니다!'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("행복하고 안전하게"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('닫기'),
      ),
    ],
  );
}

Future<String> pleasegetmyuuid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('pleasemyuuid');
  return stringValue;
}

Future<File> get _localFile async {
  String path = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOCUMENTS);
  String fullPath = "$path/Sensor_Data1.csv";
  return File(fullPath);
}

Future<int> deleteFile() async {
  try {
    final file = await _localFile;

    await file.delete();
  } catch (e) {
    return 0;
  }
}

Future<File> get _localFile1 async {
  String path1 = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  String fullPath2 = "$path1/Beacons.csv";
  return File(fullPath2);
}

Future<int> deleteBTFile() async {
  try {
    final file1 = await _localFile1;

    await file1.delete();
  } catch (e) {
    return 0;
  }
}
