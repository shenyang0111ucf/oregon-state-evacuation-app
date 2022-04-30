import 'package:evac_app/components/utility/styled_alert_dialog.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/survey_details.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

// borrowing heavily from https://github.com/quickbirdstudios/survey_kit/blob/main/example/lib/main.dart [accessed Nov 15 2021]

/// This stateful widget displays (and thus administers) a survey based on a
/// SurveyDetails object. When the survey is completed, it adds its results to
/// the appropriate DrillResults.taskResults list, then pops itself off of the
/// Navigator.

class SurveyDisplay extends StatefulWidget {
  SurveyDisplay({
    Key? key,
    required this.surveyTaskDetails,
    required this.setSurveyTaskResult,
  }) : super(key: key);

  final SurveyDetails surveyTaskDetails;
  final Function setSurveyTaskResult;
  static const valueKey = ValueKey('SurveyDisplay');
  static const printResults = true;

  @override
  _SurveyDisplayState createState() => _SurveyDisplayState();
}

class _SurveyDisplayState extends State<SurveyDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // color: Styles.backgroundColor,
            child: Align(
              alignment: Alignment.center,
              child: FutureBuilder<Task>(
                future: getTask(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    final task = snapshot.data!;
                    return DefaultTextStyle(
                      style: Styles.normalText,
                      child: SurveyKit(
                        onResult: (SurveyResult result) async {
                          await handleSurveyResult(result);
                        },
                        task: task,
                        themeData: Styles.darkCupertinoTheme,
                        confirmExitDialog: confirmExitDialog,
                      ),
                    );
                  }
                  return CircularProgressIndicator.adaptive();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  StyledAlertDialog confirmExitDialog(
      BuildContext topContext, BuildContext context) {
    return StyledAlertDialog(
      context: context,
      title: 'Exit ${widget.surveyTaskDetails.title}?',
      subtitle: 'Any answers you have provided will be lost.',
      cancelText: 'Stay Here',
      cancelFunc: () {
        Navigator.pop(context);
      },
      confirmText: 'Exit Survey',
      confirmFunc: () {
        Navigator.pop(context);
        Navigator.pop(topContext);
      },
    );
  }

  void printSurveyResults(SurveyResult result) {
    print(result.finishReason);
    if (SurveyDisplay.printResults) {
      for (var stepResult in result.results) {
        for (var questionResult in stepResult.results) {
          // Here are your question results
          print(questionResult.result);
        }
      }
    }
  }

  Future<void> handleSurveyResult(SurveyResult result) async {
    // printSurveyResults(result);
    widget.setSurveyTaskResult(result);
    Navigator.pop(context, result);
  }

  Future<Task> getTask() {
    var task = Task.fromJson(widget.surveyTaskDetails.surveyKitJson);
    return Future.value(task);
  }
}
