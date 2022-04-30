import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/survey_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';
import 'package:survey_kit/survey_kit.dart';

class SurveyTaskResult extends TaskResult {
  static const DrillTaskType _taskType = DrillTaskType.SURVEY;
  late String _taskID;
  final String title;
  final Map<String, dynamic> surveyKitJson;
  late List<Map<String, dynamic>> _surveyAnswersJson;

  DrillTaskType taskType() => _taskType;
  String taskID() => _taskID;

  SurveyTaskResult({
    required String taskID,
    required this.title,
    required this.surveyKitJson,
    required SurveyResult surveyResult,
  }) {
    _surveyAnswersJson = addSurveyResult(surveyResult);
    _taskID = taskID;
  }

  Map<String, dynamic> toJson() => {
        'taskType': _taskType.name,
        'taskID': taskID,
        'title': title,
        'surveyKitJson': surveyKitJson,
        'surveyAnswersJson': _surveyAnswersJson,
      };

  List<Map<String, dynamic>> addSurveyResult(SurveyResult result) {
    if (result.finishReason == FinishReason.COMPLETED) {
      List<Map<String, dynamic>> surveyResults = [];
      for (var stepResult in result.results) {
        Map<String, dynamic> answer = {
          "survey": title
        }; // this is accessible in SurveyTaskResult
        final questionResult = stepResult.results[0];
        if (stepResult.id != null) answer["id"] = stepResult.id!.id;
        switch (questionResult.runtimeType) {
          case InstructionStepResult:
            continue;
          case CompletionStepResult:
            continue;
          case BooleanQuestionResult:
            answer["type"] = 'bool';
            answer["response"] = questionResult.valueIdentifier;
            break;
          case IntegerQuestionResult:
            answer["type"] = 'integer';
            answer["response"] = questionResult.valueIdentifier;
            break;
          case ScaleQuestionResult:
            answer["type"] = 'scale';
            answer["response"] = questionResult.valueIdentifier;
            break;
          case MultipleChoiceQuestionResult:
            answer["type"] = 'multiple';
            answer["response"] = [];
            for (var l in questionResult.result) {
              answer["response"] += [l.text];
            }
            break;
          case SingleChoiceQuestionResult:
            answer["type"] = 'single';
            answer["response"] = questionResult.valueIdentifier;
            break;
          case TextQuestionResult:
            answer["type"] = 'text';
            answer["response"] = questionResult.valueIdentifier;
            break;
          case DateQuestionResult:
            answer["type"] = 'date';
            answer["response"] = questionResult.valueIdentifier;
            break;
          default:
            answer["type"] = 'unknown';
            answer["response"] = 'An unrecognized error has occurred.';
          // do a default thing
        }
        surveyResults += [answer];
      }
      return surveyResults;
      // print(jsonEncode(surveyResults));
    } else {
      // handle non completed survey result
      return [
        {'Error': 'Survey "$title" was not completed normally'}
      ];
    }
  }
}

/// This function returns a function.
/// The returned function will properly set a SurveyTaskResult inside of the
/// provided DrillResults' taskResults member from anywhere (below the top-level
/// function call) in the widget tree.

// top-level function
Function makeSurveyTaskResultSetter(
    DrillResults drillResults, SurveyDetails surveyDetails) {
  // returned function
  void setSurveyTaskResult(SurveyResult result) {
    // find out if there is already an `SurveyTaskResult` in `drillResults` with `taskID`
    bool haveSurveyTaskResult = false;
    int? indexOfSurveyTaskRes;
    int index = 0;
    for (TaskResult taskResult in drillResults.taskResults) {
      if (taskResult.taskType() == DrillTaskType.SURVEY) {
        if (taskResult.taskID() == surveyDetails.taskID) {
          haveSurveyTaskResult = true;
          indexOfSurveyTaskRes = index;
          break;
        }
      }
      index++;
    }

    // If there isn't a result yet, add one
    if (!haveSurveyTaskResult) {
      drillResults.taskResults.add(
        SurveyTaskResult(
          taskID: surveyDetails.taskID,
          title: surveyDetails.title,
          surveyKitJson: surveyDetails.surveyKitJson,
          surveyResult: result,
        ),
      );
    }

    // otherwise, overwrite the one we already have
    else {
      if (indexOfSurveyTaskRes == null) {
        throw Exception(
            'setAllowLocation…Result: How did we not have an index set if there is already a result?');
      }
      drillResults.taskResults[indexOfSurveyTaskRes] = SurveyTaskResult(
        taskID: surveyDetails.taskID,
        title: surveyDetails.title,
        surveyKitJson: surveyDetails.surveyKitJson,
        surveyResult: result,
      );
    }
  }

  return setSurveyTaskResult;
}
