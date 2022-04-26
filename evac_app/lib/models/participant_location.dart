import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class ParticipantLocation {
  final double latitude;
  final double longitude;
  final DateTime time;
  final double? elevation;

  ParticipantLocation({
    required this.latitude,
    required this.longitude,
    required this.time,
    this.elevation,
  });

  @override
  String toString() {
    return '{${latitude.toString()}, ${longitude.toString()}, ${time.toIso8601String()}' +
        (elevation != null ? ', ${elevation.toString()}' : '') +
        '}';
  }

  factory ParticipantLocation.fromLocationData(LocationData loc) {
    print(loc.altitude.toString());
    return ParticipantLocation(
      latitude: loc.latitude ?? 0.0,
      longitude: loc.longitude ?? 0.0,
      time: DateTime.fromMillisecondsSinceEpoch(loc.time?.toInt() ?? 0),
      elevation: loc.altitude ?? 0.0,
    );
  }

  factory ParticipantLocation.fromPosition(Position loc) {
    print(loc.altitude.toString());
    return ParticipantLocation(
      latitude: loc.latitude,
      longitude: loc.longitude,
      time: loc.timestamp ?? DateTime.now(),
      elevation: loc.altitude,
    );
  }

  // https://pub.dev/packages/json_serializable (example)
  factory ParticipantLocation.fromJson(Map<String, dynamic> json) =>
      ParticipantLocation(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        time: DateTime.parse(json['time']),
        elevation:
            ((json['elevation'] != null) ? json['elevation'] : null) as double?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'time': time.toIso8601String(),
        'elevation': elevation,
      };
}
