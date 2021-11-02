import 'dart:async';

import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/db/trajectory_database_manager.dart';
import 'package:evac_app/location_tracking/location_service.dart';
import 'package:evac_app/location_tracking/location_permissions.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _running = false;
    super.initState();
  }

  void setCurrentLocation(ParticipantLocation newLocation) {
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
    final databaseManager = TrajectoryDatabaseManager.getInstance();
    List<ParticipantLocation> dataSet = await databaseManager.getTrajectory();
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
      onPressed: createGpx,
      child: SizedBox(
        child: Text(
          'create .gpx',
          textAlign: TextAlign.center,
        ),
        width: 120,
      ),
    );
  }
}
