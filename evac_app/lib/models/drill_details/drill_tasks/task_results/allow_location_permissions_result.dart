import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/allow_location_permissions_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';

class AllowLocationPermissionsResult extends TaskResult {
  static const DrillTaskType _taskType =
      DrillTaskType.ALLOW_LOCATION_PERMISSIONS;
  late String _taskID;
  final bool allowed;

  DrillTaskType taskType() => _taskType;
  String taskID() => _taskID;

  AllowLocationPermissionsResult({
    required String taskID,
    required this.allowed,
  }) {
    _taskID = taskID;
  }

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
        'allowed': allowed,
      };
}

/// This function returns a function.
/// The returned function will properly set an Allow…Result inside of the
/// provided DrillResults' taskResults member from anywhere (below the top-level
/// function call) in the widget tree.

// top-level function
Function makeALPResultSetter(
    DrillResults drillResults, AllowLocationPermissionsDetails taskDetails) {
  // returned function
  void setAllowLocationPermissionsResult(bool result) {
    // find out if there is already an `AllowLocationPermissionsResult` in `drillResults`
    bool haveSurveyTaskResult = false;
    int? indexOfSurveyTaskRes;
    int index = 0;
    for (TaskResult taskResult in drillResults.taskResults) {
      if (taskResult.taskType == DrillTaskType.ALLOW_LOCATION_PERMISSIONS) {
        haveSurveyTaskResult = true;
        indexOfSurveyTaskRes = index;
        break;
      }
      index++;
    }

    // If there isn't a result yet, add one
    if (!haveSurveyTaskResult) {
      drillResults.taskResults.add(
        AllowLocationPermissionsResult(
          taskID: taskDetails.taskID,
          allowed: result,
        ),
      );
    }

    // otherwise, overwrite the one we already have
    else {
      if (indexOfSurveyTaskRes == null) {
        throw Exception(
            'setSurveyTaskResult: How did we not have an index set if there is already a result?');
      }
      drillResults.taskResults[indexOfSurveyTaskRes] =
          AllowLocationPermissionsResult(
        taskID: taskDetails.taskID,
        allowed: result,
      );
    }
  }

  return setAllowLocationPermissionsResult;
}
