import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/perform_drill_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';

class PerformDrillResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.PERFORM_DRILL;
  late String _taskID;
  final String title;
  final bool trackingLocation;
  final Map<String, dynamic> instructionsJson;
  DateTime startTime;
  DateTime endTime;
  Duration duration;
  double? distanceTravelled; // in (m)
  String? trajectoryFile;
  final bool completed;

  DrillTaskType taskType() => _taskType;
  String taskID() => _taskID;

  PerformDrillResult(
      {required String taskID,
      required this.title,
      required this.trackingLocation,
      required this.instructionsJson,
      required this.startTime,
      required this.endTime,
      required this.duration,
      required this.distanceTravelled,
      Future<String>? gpxFilePathFuture,
      required this.completed}) {
    _taskID = taskID;
    if (gpxFilePathFuture != null)
      setTrajectoryFileFromFuture(gpxFilePathFuture);
  }

  void setTrajectoryFileFromFuture(Future<String> gpxFilePathFuture) async {
    String filePath = await gpxFilePathFuture;
    this.trajectoryFile = filePath;
  }

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
        'title': title,
        'trackingLocation': trackingLocation,
        'instructionsJson': instructionsJson,
        'startTime': startTime,
        'endTime': endTime,
        'duration': duration,
        'distanceTravelled': distanceTravelled,
        'trajectoryFile': trajectoryFile,
        'completed': completed,
      };
}

/// This function returns a function.
/// The returned function will properly set a SurveyTaskResult inside of the
/// provided DrillResults' taskResults member from anywhere (below the top-level
/// function call) in the widget tree.

// top-level function
Function makePerformDrillResultSetter(DrillResults drillResults,
    PerformDrillDetails performDrillDetails, Function pumpState) {
  // returned function
  void setPerformDrillResult(
    DateTime startTime,
    DateTime endTime,
    Duration duration,
    double? distanceTravelled,
    Future<String> gpxFilePathFuture,
    bool completed,
  ) {
    // find out if there is already an `PerformDrillResult` in `drillResults` with `taskID`
    bool havePerformDrillResult = false;
    int? indexOfPerformDrillRes;
    int index = 0;
    for (TaskResult taskResult in drillResults.taskResults) {
      if (taskResult.taskType() == DrillTaskType.PERFORM_DRILL) {
        if (taskResult.taskID() == performDrillDetails.taskID) {
          havePerformDrillResult = true;
          indexOfPerformDrillRes = index;
          break;
        }
      }
      index++;
    }

    // If there isn't a result yet, add one
    if (!havePerformDrillResult) {
      drillResults.taskResults.add(
        PerformDrillResult(
          taskID: performDrillDetails.taskID,
          title: performDrillDetails.title,
          trackingLocation: performDrillDetails.trackingLocation,
          // locationTrackingAllowed?
          instructionsJson: performDrillDetails.instructionsJson,
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          distanceTravelled: distanceTravelled,
          gpxFilePathFuture: gpxFilePathFuture,
          completed: completed,
        ),
      );
    }

    // otherwise, overwrite the one we already have
    else {
      if (indexOfPerformDrillRes == null) {
        throw Exception(
            'setPerformDrillResult: How did we not have an index set if there is already a result?');
      }
      drillResults.taskResults[indexOfPerformDrillRes] = PerformDrillResult(
        taskID: performDrillDetails.taskID,
        title: performDrillDetails.title,
        trackingLocation: performDrillDetails.trackingLocation,
        // locationTrackingAllowed?
        instructionsJson: performDrillDetails.instructionsJson,
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        distanceTravelled: distanceTravelled,
        gpxFilePathFuture: gpxFilePathFuture,
        completed: completed,
      );
    }
    pumpState(() => null);
  }

  return setPerformDrillResult;
}
