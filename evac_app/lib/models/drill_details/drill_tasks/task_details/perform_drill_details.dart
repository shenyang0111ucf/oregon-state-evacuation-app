import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';

class PerformDrillDetails extends TaskDetails {
  final String taskID;
  final bool trackingLocation;
  final Map<String, dynamic> instructionsJson;
  // outputFormat String?,
  //               enum oF{GPX,GEOJSON,RAW}?,

  PerformDrillDetails({
    required this.taskID,
    required this.trackingLocation,
    required this.instructionsJson,
  });

  PerformDrillDetails.example()
      : taskID = 'abc123',
        trackingLocation = true,
        instructionsJson = {};

  factory PerformDrillDetails.fromJson(Map<String, dynamic> json) =>
      PerformDrillDetails(
        taskID: json['taskID'],
        trackingLocation: json['trackingLocation'],
        instructionsJson: json['instructionsJson'],
      );

  Map<String, dynamic> toJson() => {
        'taskID': taskID,
        'trackingLocation': trackingLocation,
        'instructionsJson': instructionsJson,
      };
}
