import 'dart:async';
import 'dart:io';

import 'package:evac_app/db/trajectory_database_manager.dart';
import 'package:evac_app/gpx_export/create_gpx.dart';
import 'package:evac_app/location_tracking/location_permissions.dart';
import 'package:evac_app/location_tracking/location_service.dart';
import 'package:path_provider/path_provider.dart';

// https://github.com/filiph/hn_app/blob/master/lib/src/notifiers/worker.dart

class LocationTracker {
  final databaseManager = TrajectoryDatabaseManager.getInstance();
  bool _running = false;
  LocationService? locationService;
  StreamSubscription? subscription;

  LocationTracker() {}

  void startLogging() async {
    if (!_running) {
      String result = await canUseLocation();
      if (result == 'yes') {
        print('location available');
        locationService = LocationService();
        // this line makes sure that if a second drill is run while app is still
        // open, the data from the end of the last drill is not erroneously put
        // into the results for the new drill
        LocationService.stream!.drain();
        subscription = LocationService.stream!.listen(
            (newLocation) => _setCurrentLocation(databaseManager, newLocation));
        _running = true;
      } else {
        print('location not available');
      }
    }
  }

  void stopLogging() {
    if (_running) {
      subscription!.cancel();
      locationService = null;
      subscription = null;
      _running = false;
    }
  }

  Future<String> createTrajectory(filename) async {
    // if able to create gpx
    final directory = await getApplicationDocumentsDirectory();
    var exists = Directory(directory.path + '/gpxFiles/').existsSync();
    if (!exists) {
      Directory(directory.path + '/gpxFiles/').createSync();
    }
    var file = File(directory.path + '/gpxFiles/' + filename + '.gpx');
    exists = file.existsSync();
    if (exists) {
      file.deleteSync();
    }
    //  + '-' + DateTime.now().toIso8601String().substring(0,19)
    await CreateGpx().fromList(file);
    await _clearDB(databaseManager);
    return file.path;
  }

  // right now we are throwing away any results if they back out. In the future we should have much more complex location logging, with pause+resume, etc.

  static void _setCurrentLocation(databaseManager, newLocation) async {
    await databaseManager.insert(location: newLocation);
  }

  static Future<void> _clearDB(
      TrajectoryDatabaseManager databaseManager) async {
    await databaseManager.wipeData();
    return;
  }
}
