import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/travel_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';

class TravelResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.TRAVEL;
  late String _taskID;

  DrillTaskType taskType() => _taskType;
  String taskID() => _taskID;

  TravelResult({
    required String taskID,
  }) {
    _taskID = taskID;
  }

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
      };
}

/// This function returns a function.
/// The returned function will properly set a SurveyTaskResult inside of the
/// provided DrillResults' taskResults member from anywhere (below the top-level
/// function call) in the widget tree.

// top-level function:
Function makeTravelResultSetter(DrillResults drillResults,
    TravelDetails travelDetails, Function pumpState) {
  // returned function:
  void setTravelResult() {
    // find out if there is already an `TravelResult` in `drillResults` with `taskID`
    bool haveTravelResult = false;
    int? indexOfTravelRes;
    int index = 0;
    for (TaskResult taskResult in drillResults.taskResults) {
      if (taskResult.taskType() == DrillTaskType.TRAVEL) {
        if (taskResult.taskID() == travelDetails.taskID) {
          haveTravelResult = true;
          indexOfTravelRes = index;
          break;
        }
      }
      index++;
    }

    // If there isn't a result yet, add one
    if (!haveTravelResult) {
      drillResults.taskResults.add(
        TravelResult(taskID: travelDetails.taskID),
      );
    }

    // otherwise, overwrite the one we already have
    else {
      if (indexOfTravelRes == null) {
        throw Exception(
            'setTravelResult: How did we not have an index set if there is already a result?');
      }
      drillResults.taskResults[indexOfTravelRes] =
          TravelResult(taskID: travelDetails.taskID);
    }
    pumpState(() => null);
  }

  return setTravelResult;
}
