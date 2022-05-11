import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';

class AllowLocationPermissionsDetails extends TaskDetails {
  final String taskID;

  AllowLocationPermissionsDetails({
    required this.taskID,
  });

  AllowLocationPermissionsDetails.example(this.taskID);

  factory AllowLocationPermissionsDetails.fromJson(Map<String, dynamic> json) =>
      AllowLocationPermissionsDetails(taskID: json['taskID']);

  Map<String, dynamic> toJson() => {'taskID': taskID};
}
