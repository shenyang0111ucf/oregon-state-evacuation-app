import 'dart:async';

import 'package:evac_app/models/participant_location.dart';
import 'package:location/location.dart';

class LocationService {
  var location = Location();
  static Stream? stream;

  LocationService() {
    getLocation();
    location.changeSettings(distanceFilter: 0.5);
    // location.enableBackgroundMode(enable: true);
    stream = location.onLocationChanged.map(
        (locationData) => ParticipantLocation.fromLocationData(locationData));
  }

  void getLocation() async {
    try {
      var firstData = await location.getLocation();
      print(firstData);
    } on Exception catch (e) {
      print('No good: ${e.toString()}');
    }
  }
}
