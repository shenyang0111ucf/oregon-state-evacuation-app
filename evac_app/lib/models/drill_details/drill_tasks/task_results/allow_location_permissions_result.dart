import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class AllowLocationPermissionsResult extends TaskResult {
  static const DrillTaskType taskType =
      DrillTaskType.ALLOW_LOCATION_PERMISSIONS;
  final int taskID;
  final bool allowed;

  AllowLocationPermissionsResult({
    required this.taskID,
    required this.allowed,
  });

  Map<String, dynamic> toJson() => {
        'taskType': taskType,
        'taskID': taskID,
        'allowed': allowed,
      };
}
