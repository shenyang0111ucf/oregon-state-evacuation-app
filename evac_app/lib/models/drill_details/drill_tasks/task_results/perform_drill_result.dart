import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class PerformDrillResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.PERFORM_DRILL;
  final String taskID;
  final String title;
  final bool trackingLocation;
  final Map<String, dynamic> instructionsJson;
  DateTime startTime;
  DateTime endTime;
  Duration? duration;
  double? distanceTravelled; // in (m)
  String? trajectoryFile;

  DrillTaskType taskType() => _taskType;

  PerformDrillResult({
    required this.taskID,
    required this.title,
    required this.trackingLocation,
    required this.instructionsJson,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.distanceTravelled,
    required this.trajectoryFile,
  });

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
      };
}
