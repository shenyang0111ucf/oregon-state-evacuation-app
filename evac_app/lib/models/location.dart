class Location {
  final double latitude;
  final double longitude;
  final DateTime time;
  final double? elevation;

  Location({
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

  // https://pub.dev/packages/json_serializable (example)
  factory Location.fromJson(Map<String, dynamic> json) => Location(
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
