import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class TravelResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.TRAVEL;
  final String taskID;

  DrillTaskType taskType() => _taskType;

  TravelResult({required this.taskID});

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
      };
}
