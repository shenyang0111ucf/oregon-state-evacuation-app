import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class PerformDrillResult extends TaskResult {
  static const DrillTaskType taskType = DrillTaskType.PERFORM_DRILL;
  final int taskID;
  final bool trackingLocation;
  final Map<String, dynamic> instructionsJson;
  DateTime startTime;
  DateTime endTime;
  Duration? duration;
  double? distanceTravelled; // in (m)
  String? trajectoryFile;

  PerformDrillResult({
    required this.taskID,
    required this.trackingLocation,
    required this.instructionsJson,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.distanceTravelled,
    required this.trajectoryFile,
  });

  Map<String, dynamic> toJson() => {
        'taskType': taskType,
        'taskID': taskID,
        'trackingLocation': trackingLocation,
        'instructionsJson': instructionsJson,
        'startTime': startTime,
        'endTime': endTime,
        'duration': duration,
        'distanceTravelled': distanceTravelled,
        'trajectoryFile': trajectoryFile,
      };
}
