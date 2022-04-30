import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class SurveyTaskResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.SURVEY;
  final String taskID;
  final String title;
  final Map<String, dynamic> surveyKitJson;
  final Map<String, dynamic> surveyAnswersJson;

  DrillTaskType taskType() => _taskType;

  SurveyTaskResult({
    required this.taskID,
    required this.title,
    required this.surveyKitJson,
    required this.surveyAnswersJson,
  });

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
        'title': title,
        'surveyKitJson': surveyKitJson,
        'surveyAnswersJson': surveyAnswersJson,
      };
}
