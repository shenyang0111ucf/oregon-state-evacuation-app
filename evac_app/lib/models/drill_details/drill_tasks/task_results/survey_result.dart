import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';

class SurveyResult extends TaskResult {
  static const DrillTaskType taskType = DrillTaskType.SURVEY;
  final int taskID;
  final String title;
  final Map<String, dynamic> surveyKitJson;
  final Map<String, dynamic> surveyAnswersJson;

  SurveyResult({
    required this.taskID,
    required this.title,
    required this.surveyKitJson,
    required this.surveyAnswersJson,
  });

  Map<String, dynamic> toJson() => {
        'taskType': taskType,
        'taskID': taskID,
        'title': title,
        'surveyKitJson': surveyKitJson,
        'surveyAnswersJson': surveyAnswersJson,
      };
}
