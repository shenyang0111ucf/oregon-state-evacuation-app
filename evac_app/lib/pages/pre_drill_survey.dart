import 'package:evac_app/components/evac_app_scaffold_no_app_bar.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

// borrowing heavily from https://github.com/quickbirdstudios/survey_kit/blob/main/example/lib/main.dart [accessed Nov 15 2021]

class PreDrillSurvey extends StatefulWidget {
  PreDrillSurvey({
    Key? key,
    required this.drillEvent,
  }) : super(key: key);

  final DrillEvent drillEvent;
  static const valueKey = ValueKey('PreDrillSurvey');
  static const printResults = false;

  @override
  _PreDrillSurveyState createState() => _PreDrillSurveyState();
}

class _PreDrillSurveyState extends State<PreDrillSurvey> {
  @override
  Widget build(BuildContext context) {
    return EvacAppScaffoldNoAppBar(
      title: 'pre drill survey',
      child: Container(
        color: Styles.backgroundColor,
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
                      await handlePreDrillResult(result);
                    },
                    task: task,
                    themeData: Styles.darkCupertinoTheme,
                  ),
                );
              }
              return CircularProgressIndicator.adaptive();
            },
          ),
        ),
      ),
    );
  }

  void printPreDrillResults(SurveyResult result) {
    print(result.finishReason);
    if (PreDrillSurvey.printResults) {
      for (var stepResult in result.results) {
        for (var questionResult in stepResult.results) {
          // Here are your question results
          print(questionResult.result);
        }
      }
    }
  }

  Future<void> handlePreDrillResult(SurveyResult result) async {
    printPreDrillResults(result);
    Navigator.pop(context, result);
  }

  Future<Task> getTask() {
    var task = Task.fromJson(widget.drillEvent.preDrillSurveyJSON);
    return Future.value(task);
  }
}
