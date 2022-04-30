import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/wait_for_start_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';

class WaitForStartResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.WAIT_FOR_START;
  late String _taskID;
  final String performDrillTaskID;
  final TypeOfWait typeOfWait;
  final bool complete;

  DrillTaskType taskType() => _taskType;
  String taskID() => _taskID;

  WaitForStartResult({
    required String taskID,
    required this.performDrillTaskID,
    required this.complete,
  }) : typeOfWait = TypeOfWait.SELF {
    _taskID = taskID;
  }

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
        'performDrillTaskID': performDrillTaskID,
        'typeOfWait': typeOfWait.name,
        'complete': complete,
      };
}

/// This function returns a function.
/// The returned function will properly set a SurveyTaskResult inside of the
/// provided DrillResults' taskResults member from anywhere (below the top-level
/// function call) in the widget tree.

// top-level function:
Function makeWaitForStartResultSetter(
    DrillResults drillResults, WaitForStartDetails waitForStartDetails) {
  // returned function:
  void setWaitForStartResult(bool result) {
    // find out if there is already an `WaitForStartResult` in `drillResults` with `taskID`
    bool haveWaitForStartResult = false;
    int? indexOfWaitForStartRes;
    int index = 0;
    for (TaskResult taskResult in drillResults.taskResults) {
      if (taskResult.taskType == DrillTaskType.WAIT_FOR_START) {
        if (taskResult.taskID == waitForStartDetails.taskID) {
          haveWaitForStartResult = true;
          indexOfWaitForStartRes = index;
          break;
        }
      }
      index++;
    }

    // If there isn't a result yet, add one
    if (!haveWaitForStartResult) {
      drillResults.taskResults.add(
        WaitForStartResult(
          taskID: waitForStartDetails.taskID,
          performDrillTaskID: waitForStartDetails.performDrillTaskID,
          complete: result,
        ),
      );
    }

    // otherwise, overwrite the one we already have
    else {
      if (indexOfWaitForStartRes == null) {
        throw Exception(
            'setWaitForStartResult: How did we not have an index set if there is already a result?');
      }
      drillResults.taskResults[indexOfWaitForStartRes] = WaitForStartResult(
        taskID: waitForStartDetails.taskID,
        performDrillTaskID: waitForStartDetails.performDrillTaskID,
        complete: result,
      );
    }
  }

  return setWaitForStartResult;
}
