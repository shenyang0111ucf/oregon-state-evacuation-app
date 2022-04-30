import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class AllowLocationPermissionsResult extends TaskResult {
  static const DrillTaskType _taskType =
      DrillTaskType.ALLOW_LOCATION_PERMISSIONS;
  final String taskID;
  final bool allowed;

  DrillTaskType taskType() => _taskType;

  AllowLocationPermissionsResult({
    required this.taskID,
    required this.allowed,
  });

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
        'allowed': allowed,
      };
}
