import 'dart:async';

import 'package:evac_app/models/participant_location.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';

// https://stackoverflow.com/questions/60628321/how-to-set-an-interval-to-the-flutter-location-receiving-data

class LocationService {
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 2,
  );
  late Stream<ParticipantLocation> stream;

  LocationService() {
    stream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((locationData) => ParticipantLocation.fromPosition(locationData));
    print('broadcast?: ${stream.isBroadcast}');
  }

  Future<ParticipantLocation?> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return ParticipantLocation.fromPosition(position);
    } on Exception catch (e) {
      print('No good: ${e.toString()}');
      return null;
    }
  }

  // void stopTracking() {
  //   stream = null;
  // }
}
