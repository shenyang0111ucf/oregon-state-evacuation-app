// import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:survey_kit/survey_kit.dart';

class DrillResult {
  String? _gpxFilePath;
  List<Map<String, dynamic>>? _preDrillSurveyResults;
  List<Map<String, dynamic>>? _postDrillSurveyResults;
  Duration? _timeElapsed;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _operatingSystem;

  // DrillResult should only be initialized empty! then add results as progress is made
  DrillResult();

  /// #100: This Function should add the current time to the _startTime field, if
  /// _startTime is null.
  void addStartTime() {
    // could use DateTime.now() ?
  }

  /// #100: This Function should add the current time to the _endTime field, if
  /// _endTime is null.
  void addEndTime() {
    // could use DateTime.now() ?
  }

  /// #100: This Function should add the running OS to the _operatingSystem
  /// field.
  void addOperatingSystem() {
    // https://stackoverflow.com/a/50744481/14962174
  }

  bool hasPreDrillResult() {
    return (_preDrillSurveyResults != null);
  }

  String printPreDrillResult() {
    return jsonEncode(_preDrillSurveyResults);
  }

  bool hasTimeElapsed() {
    return _timeElapsed != null;
  }

  String printTimeElapsed() {
    return _timeElapsed.toString();
  }

  Map<String, dynamic> _timeElapsedMap() {
    return {"timeElapsed": printTimeElapsed()};
  }

  bool hasPostDrillResult() {
    return _postDrillSurveyResults != null;
  }

  String printPostDrillResult() {
    return jsonEncode(_postDrillSurveyResults);
  }

  File getGpxFile() {
    // DANGER! does not null check _gpxFilePath
    // haphazard, please rearchitect results_exporter, etc.
    return File(_gpxFilePath!);
  }

  void addSurveyResult(SurveyResult result) {
    if (result.finishReason == FinishReason.COMPLETED) {
      var survey;
      if (result.id == Identifier(id: 'preDrillSurvey')) {
        survey = 'preDrillSurvey';
      } else if (result.id == Identifier(id: 'postDrillSurvey')) {
        survey = 'postDrillSurvey';
      } else {
        throw Exception('undefined survey result type, cannot save');
      }
      List<Map<String, dynamic>> surveyResults = [];
      for (var stepResult in result.results) {
        Map<String, dynamic> answer = {"survey": survey};
        final questionResult = stepResult.results[0];
        if (stepResult.id != null) answer["id"] = stepResult.id!.id;
        switch (questionResult.runtimeType) {
          case InstructionStepResult:
            continue;
            break;
          case CompletionStepResult:
            continue;
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
        surveyResults += [answer];
      }
      if (result.id == Identifier(id: 'preDrillSurvey')) {
        _preDrillSurveyResults = surveyResults;
      } else if (result.id == Identifier(id: 'postDrillSurvey')) {
        _postDrillSurveyResults = surveyResults;
      }
      // print(jsonEncode(surveyResults));
    }
  }

  Future addGpxFile(Future<String> gpxFile) async {
    String filePath = await gpxFile;
    this._gpxFilePath = filePath;
  }

  String? exportSurveyResultsToJsonString() {
    if (_preDrillSurveyResults != null && _postDrillSurveyResults != null) {
      List answers = _preDrillSurveyResults! + _postDrillSurveyResults!;
      Map<String, dynamic> results = {
        ...{'answers': answers},
        ..._timeElapsedMap(),
      };
      print(jsonEncode(results));
      return jsonEncode(results);
    } else {
      return null;
    }
  }
}
