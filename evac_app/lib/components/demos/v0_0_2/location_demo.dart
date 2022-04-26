import 'dart:async';
import 'dart:io';
import 'package:evac_app/db/trajectory_database_manager.dart';
import 'package:evac_app/styles.dart';
import 'package:http/http.dart' as http;

// import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/gpx_export/create_gpx.dart';
import 'package:evac_app/location_tracking/location_service.dart';
import 'package:evac_app/location_tracking/location_permissions.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:evac_app/styles.dart';
import 'package:evac_app/models/participant_location.dart';

class LocationDemo extends StatefulWidget {
  const LocationDemo({Key? key}) : super(key: key);

  @override
  _LocationDemoState createState() => _LocationDemoState();
}

class _LocationDemoState extends State<LocationDemo> {
  bool? _running;
  LocationService? locationService;
  StreamSubscription? subscription;
  ParticipantLocation? currentLocation;
  int fileCounter = 0;
  int exportCounter = 0;
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
        // subscription = LocationService.stream!
        subscription = locationService!.stream
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
    while (exportCounter < fileCounter) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '/test' + exportCounter.toString() + '.gpx';
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
      exportCounter++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (_running!) ? currentLocationDisplay(context) : const SizedBox(),
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

  Widget currentLocationDisplay(BuildContext context) {
    Widget elevation = Text(
      currentLocation?.elevation != null
          ? currentLocation!.elevation!.toStringAsFixed(1) + ' m'
          : 'no elev',
      style: Styles.normalText.copyWith(fontSize: 66.0),
    );
    Widget elevationFeet = Text(
      currentLocation?.elevation != null
          ? (currentLocation!.elevation! * 3.28084).toStringAsFixed(0) + ' ft'
          : 'no elev',
      style: Styles.boldText.copyWith(fontSize: 66.0),
    );
    Widget lat = Text(
      currentLocation?.latitude.toStringAsPrecision(7) ?? 'no lat',
      style: Styles.normalText.copyWith(fontSize: 32.0),
    );
    Widget long = Text(
      currentLocation?.longitude.toStringAsPrecision(7) ?? 'no long',
      style: Styles.normalText.copyWith(fontSize: 32.0),
    );
    Widget tim = Text(
      currentLocation?.time != null
          ? currentLocation!.time.hour.toString() +
              ':' +
              (currentLocation!.time.minute < 10
                  ? '0' + currentLocation!.time.minute.toString()
                  : currentLocation!.time.minute.toString()) +
              ';' +
              (currentLocation!.time.second < 10
                  ? '0' + currentLocation!.time.second.toString()
                  : currentLocation!.time.second.toString())
          : 'no tim',
      style: Styles.normalText.copyWith(fontSize: 32.0),
    );
    return Column(
      children: [
        elevation,
        elevationFeet,
        lat,
        long,
        tim,
      ],
    );
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
