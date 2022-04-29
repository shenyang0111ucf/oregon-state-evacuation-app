import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/allow_location_permissions_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/perform_drill_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/survey_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/travel_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/wait_for_start_details.dart';

/// Drills are made up of the tasks which participants complete within the duration. This DrillTask model allows DrillDetails to include the details that describe these tasks.

class DrillTask {
  final int index; // add during parse on mobile
  final String taskID;
  final DrillTaskType taskType;
  final TaskDetails details;

  DrillTask({
    required this.index,
    required this.taskID,
    required this.taskType,
    required this.details,
  });

  factory DrillTask.fromJson(Map<String, dynamic> json, int index) {
    TaskDetails? taskDetails;
    // not sure if this works...
    switch (json['taskType']) {
      case DrillTaskType.ALLOW_LOCATION_PERMISSIONS:
        taskDetails = AllowLocationPermissionsDetails.fromJson(json['details']);
        break;
      case DrillTaskType.PERFORM_DRILL:
        taskDetails = PerformDrillDetails.fromJson(json['details']);
        break;
      case DrillTaskType.SURVEY:
        taskDetails = SurveyDetails.fromJson(json['details']);
        break;
      case DrillTaskType.TRAVEL:
        taskDetails = TravelDetails.fromJson(json['details']);
        break;
      case DrillTaskType.WAIT_FOR_START:
        taskDetails = WaitForStartDetails.fromJson(json['details']);
        break;
    }

    if (taskDetails != null) {
      return DrillTask(
        index: index,
        taskID: json['taskID'],
        // not sure if this works...
        taskType: json['taskType'],
        details: taskDetails,
      );
    } else {
      throw Exception(
          'DrillTask: DrillTaskType did not match any enumerated type value.');
    }
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'taskID': taskID,
        'taskType': taskType,
        'details': details.toJson(),
      };
}
