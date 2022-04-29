import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class WaitForStartResult extends TaskResult {
  static const DrillTaskType taskType = DrillTaskType.WAIT_FOR_START;
  final int taskID;
  final int performDrillTaskID;
  final TypeOfWait typeOfWait;

  WaitForStartResult({
    required this.taskID,
    required this.performDrillTaskID,
  }) : typeOfWait = TypeOfWait.SELF;

  Map<String, dynamic> toJson() => {
        'taskType': taskType,
        'taskID': taskID,
        'performDrillTaskID': performDrillTaskID,
        'typeOfWait': typeOfWait,
      };
}
