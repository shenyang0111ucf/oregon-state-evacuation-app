import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';

class TravelDetails extends TaskDetails {
  final String taskID;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final String blurb;
  final String? explanation;
  final DateTime? meetingTime;
  final String? imageURL;
  final String? mapImageURL;
  final String? mapsLink;
  // can the above be generated for google maps by latitude + longitude? yes, but maybe they want to link to a place, like a named building, google maps is the best database for this anyways let them link how they choose. Then if no link make a google maps link why not.

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

  TravelDetails.example(this.locationName, this.blurb, this.taskID)
      : latitude = 45.460813,
        longitude = -123.970422,
        // blurb = 'A park in Oceanside.',
        explanation = null,
        // explanation =
        //     'A long ass explanation that needs to wrap and wrap and wrap and wrap and wrap and wrap to fit',
        meetingTime = null,
        // meetingTime = DateTime.now(),
        imageURL =
            'https://upload.wikimedia.org/wikipedia/commons/1/12/Oceanside_Oregon.jpg',
        mapImageURL =
            'https://firebasestorage.googleapis.com/v0/b/evacuation-drill-app-osu.appspot.com/o/images%2FoceansideBeachStatePark.png?alt=media&token=0d96d273-29cd-4117-bca3-c5b942d12850',
        mapsLink =
            'https://www.google.com/maps/place/Oceanside+Beach+State+Park,+Oregon+97141/';

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
