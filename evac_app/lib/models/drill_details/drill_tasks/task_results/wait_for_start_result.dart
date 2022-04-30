import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class WaitForStartResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.WAIT_FOR_START;
  final String taskID;
  final int performDrillTaskID;
  final TypeOfWait typeOfWait;

  DrillTaskType taskType() => _taskType;

  WaitForStartResult({
    required this.taskID,
    required this.performDrillTaskID,
  }) : typeOfWait = TypeOfWait.SELF;

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
        'performDrillTaskID': performDrillTaskID,
        'typeOfWait': typeOfWait.name,
      };
}
