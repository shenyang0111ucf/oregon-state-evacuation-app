import 'package:evac_app/components/evac_app_scaffold_no_app_bar.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

// borrowing heavily from https://github.com/quickbirdstudios/survey_kit/blob/main/example/lib/main.dart [accessed Nov 15 2021]

class PostDrillSurvey extends StatefulWidget {
  PostDrillSurvey({
    Key? key,
    required this.drillEvent,
  }) : super(key: key);

  final DrillEvent drillEvent;
  static const valueKey = ValueKey('PostDrillSurvey');
  static const printResults = true;

  @override
  _PostDrillSurveyState createState() => _PostDrillSurveyState();
}

class _PostDrillSurveyState extends State<PostDrillSurvey> {
  @override
  Widget build(BuildContext context) {
    return EvacAppScaffoldNoAppBar(
      title: 'post drill survey',
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
                      await handlePostDrillResult(result);
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

  void printPostDrillResults(SurveyResult result) {
    print(result.finishReason);
    if (PostDrillSurvey.printResults) {
      for (var stepResult in result.results) {
        for (var questionResult in stepResult.results) {
          // Here are your question results
          print(questionResult.result);
        }
      }
    }
  }

  Future<void> handlePostDrillResult(SurveyResult result) async {
    printPostDrillResults(result);
    Navigator.pop(context, result);
  }

  Future<Task> getTask() {
    var task = Task.fromJson(widget.drillEvent.postDrillSurveyJSON);
    return Future.value(task);
  }
}
