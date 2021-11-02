import 'dart:async';

import 'package:evac_app/models/participant_location.dart';
import 'package:location/location.dart';

class LocationService {
  var location = Location();
  static Stream? stream;

  LocationService() {
    getLocation();
    // location.enableBackgroundMode(enable: true);
    stream = location.onLocationChanged.map(
        (locationData) => ParticipantLocation.fromLocationData(locationData));
  }

  void getLocation() async {
    await location.changeSettings(distanceFilter: 2);
    try {
      var firstData = await location.getLocation();
      print(firstData);
    } on Exception catch (e) {
      print('No good: ${e.toString()}');
    }
  }
}
