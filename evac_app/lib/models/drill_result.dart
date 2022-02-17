import 'dart:convert';
import 'dart:io';

import 'package:survey_kit/survey_kit.dart';

class DrillResult {
  File? _gpxFile;
  Map<String, dynamic>? _preDrillSurveyResults;
  Map<String, dynamic>? _postDrillSurveyResults;

  // DrillResult should only be initialized empty! then add results as progress is made
  DrillResult();

  bool hasPreDrillResult() {
    return _preDrillSurveyResults != null;
  }

  bool hasPostDrillResult() {
    return _postDrillSurveyResults != null;
  }

  void addSurveyResult(SurveyResult result) {
    if (result.finishReason == FinishReason.COMPLETED) {
      Map<String, dynamic> surveyResults = {"answers": []};
      for (var stepResult in result.results) {
        Map<String, dynamic> answer = {};
        final questionResult = stepResult.results[0];
        if (stepResult.id != null) answer["id"] = stepResult.id!.id;
        switch (questionResult.runtimeType) {
          case InstructionStepResult:
            break;
          case CompletionStepResult:
            break;
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
        surveyResults["answers"] += [answer];
      }
      if (result.id == Identifier(id: 'preDrillSurvey')) {
        surveyResults["id"] = 'preDrillSurvey';
        _preDrillSurveyResults = surveyResults;
      } else if (result.id == Identifier(id: 'postDrillSurvey')) {
        surveyResults["id"] = 'postDrillSurvey';
        _postDrillSurveyResults = surveyResults;
      }
      // print(jsonEncode(surveyResults));
    }
  }

  Future addGpxFile(File gpxFile) async {
    this._gpxFile = gpxFile;
  }

  Map<String, dynamic>? exportSurveyResultsToJsonAndGetFile() {
    // probably need better error handling here!!!
    // like what if the predrillsurveyresults get boofed for some reason but we still have a gpxFile and postResults? gotta export what we have.................
    if (_preDrillSurveyResults != null && _postDrillSurveyResults != null) {
      // export the results
      if (_gpxFile != null) {
        // also export the file
      }
    } else {
      return null;
    }
  }
}
