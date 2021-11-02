import 'dart:async';
import 'dart:io';
import 'package:evac_app/db/trajectory_database_manager.dart';
import 'package:http/http.dart' as http;

import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/gpx_export/create_gpx.dart';
import 'package:evac_app/location_tracking/location_service.dart';
import 'package:evac_app/location_tracking/location_permissions.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './styles.dart';
import 'models/participant_location.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool? _running;
  LocationService? locationService;
  StreamSubscription? subscription;
  ParticipantLocation? currentLocation;
  int fileCounter = 0;
  bool canCreateGpx = true;
  bool canExportGpx = true;

  @override
  void initState() {
    _running = false;
    super.initState();
  }

  void setCurrentLocation(ParticipantLocation newLocation) async {
    final databaseManager = TrajectoryDatabaseManager.getInstance();
    await databaseManager.insert(location: newLocation);
    setState(() {
      currentLocation = newLocation;
    });
  }

  void toggleRunning() async {
    if (!_running!) {
      String result = await canUseLocation();
      if (result == 'yes') {
        print('location available');
        locationService = LocationService();
        subscription = LocationService.stream!
            .listen((newLocation) => setCurrentLocation(newLocation));
        setState(() {
          _running = true;
        });
      } else {
        print('location not available');
      }
    } else {
      // locationService!.stopService();
      subscription!.cancel();
      locationService = null;
      subscription = null;
      setState(() {
        _running = false;
      });
    }
  }

  void createGpx() async {
    setState(() {
      canCreateGpx = false;
    });
    final directory = await getApplicationDocumentsDirectory();
    var file = File(directory.path + '/test' + fileCounter.toString() + '.gpx');
    while (await file.exists()) {
      print('having to increment file name...');
      fileCounter++;
      file = File(directory.path + '/test' + fileCounter.toString() + '.gpx');
    }
    await CreateGpx().fromList(file);
    setState(() {
      canCreateGpx = true;
    });
  }

  void exportGpx() async {
    // https://firebase.flutter.dev/docs/storage/usage/#file-uploads

    final directory = await getApplicationDocumentsDirectory();
    final fileName = '/test' + fileCounter.toString() + '.gpx';
    final filepath = directory.path + fileName;
    var file = File(filepath);
    final port = 8081.toString();
    final address = '192.168.0.192';
    final baseURL = 'http://' + address + ':' + port;
    final response = await http.post(
      Uri.parse(baseURL + '/trajectories'),
      body: await file.readAsString(),
      headers: {
        'Content-Type': 'application/xml',
        'Content-Location': fileName,
      },
    );
    if (response.statusCode == 200) {
      print('good upload');
    } else {
      print('pas compris :(');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: Styles.darkTheme,
      home: EvacAppScaffold(
        title: widget.title,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_running!) ? currentLocationText(context) : SizedBox(),
              runningToggleButton(context),
              SizedBox(height: 10),
              createGpxButton(context),
              SizedBox(height: 10),
              exportGpxButton(context),
              SizedBox(height: 10),
              deleteDatabaseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget runningToggleButton(BuildContext context) {
    return ElevatedButton(
      child: SizedBox(
        child: Text(
          (_running!) ? 'Stop' : 'Start',
          textAlign: TextAlign.center,
        ),
        width: 60,
      ),
      onPressed: toggleRunning,
    );
  }

  Widget currentLocationText(BuildContext context) {
    return Text(currentLocation.toString());
  }

  Widget createGpxButton(BuildContext context) {
    return ElevatedButton(
      onPressed: (canCreateGpx) ? createGpx : null,
      child: SizedBox(
        child: Text(
          'create .gpx',
          textAlign: TextAlign.center,
        ),
        width: 120,
      ),
    );
  }

  Widget exportGpxButton(BuildContext context) {
    return ElevatedButton(
      onPressed: (canExportGpx) ? exportGpx : null,
      child: SizedBox(
        child: Text(
          'export .gpx',
          textAlign: TextAlign.center,
        ),
        width: 120,
      ),
    );
  }

  Widget deleteDatabaseButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final databaseManager = TrajectoryDatabaseManager.getInstance();
        databaseManager.wipeData();
      },
      child: SizedBox(
        child: Text(
          'delete currently stored trajectory',
          textAlign: TextAlign.center,
        ),
        width: 240,
      ),
    );
  }
}
