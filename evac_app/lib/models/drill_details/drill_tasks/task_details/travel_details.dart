import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';

class TravelDetails extends TaskDetails {
  final String taskID;
  final String locationName;
  final double latitude;
  final double longitude;
  final String blurb;
  final String? explanation;
  final DateTime? meetingTime;
  final String? imageURL;
  final String? mapImageURL;
  final String?
      mapsLink; // can this be generated for google maps by latitude + longitude? yes, but maybe they want to link to a place, like a named building, google maps is the best database for this anyways let them link how they choose. Then if no link make a google maps link why not.

  TravelDetails({
    required this.taskID,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.blurb,
    required this.explanation,
    required this.meetingTime,
    required this.imageURL,
    required this.mapImageURL,
    required this.mapsLink,
  });

  TravelDetails.example(this.locationName)
      : taskID = 'abc123',
        latitude = 45.460813,
        longitude = -123.970422,
        blurb = 'A park in Oceanside.',
        explanation = null,
        meetingTime = null,
        imageURL = null,
        mapImageURL = null,
        mapsLink =
            'https://www.google.com/maps/dir//Oceanside,+Oregon+97141/@45.4606578,-123.9705637,18.46z/';

  factory TravelDetails.fromJson(Map<String, dynamic> json) => TravelDetails(
        taskID: json['taskID'],
        locationName: json['locationName'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        blurb: json['blurb'],
        explanation: json['explanation'],
        meetingTime: json['meetingTime'],
        imageURL: json['imageURL'],
        mapImageURL: json['mapImageURL'],
        mapsLink: json['mapsLink'],
      );

  Map<String, dynamic> toJson() => {
        'taskID': taskID,
        'locationName': locationName,
        'latitude': latitude,
        'longitude': longitude,
        'blurb': blurb,
        'explanation': explanation,
        'meetingTime': meetingTime,
        'imageURL': imageURL,
        'mapImageURL': mapImageURL,
        'mapsLink': mapsLink,
      };
}
