import 'package:evac_app/models/participant_location.dart';
import 'package:location/location.dart';

// thank you to https://www.filledstacks.com/snippet/build-a-flutter-location-service/ for the excellent tutorial.
// also thank you to Yong Bakos and his CS 472 coursework for equivalent information

class LocationService {
  ParticipantLocation _currentLocation;

  var location = Location();

  Future<ParticipantLocation> getLocation() async {
    try {
      var participantLocation = await location.getLocation();
      _currentLocation = ParticipantLocation(latitude: participantLocation.latitude ?? 0.0, longitude: longitude, time: time,)
    } catch (e) {
      print('Could not get location: ${e.toString()}');
    }
  }
}
