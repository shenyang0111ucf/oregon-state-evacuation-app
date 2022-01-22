import 'package:evac_app/components/evac_app_scaffold_no_app_bar.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class ConfirmDrill extends StatefulWidget {
  const ConfirmDrill({
    Key? key,
  }) : super(key: key);

  static const valueKey = ValueKey('ConfirmDrill');

  @override
  _ConfirmDrillState createState() => _ConfirmDrillState();
}

class _ConfirmDrillState extends State<ConfirmDrill> {
  @override
  Widget build(BuildContext context) {
    // TODO: rebuild this without surveykit
    return EvacAppScaffoldNoAppBar(
      title: 'pre drill survey',
      child: SurveyKit(
        onResult: (SurveyResult result) async {
          // I'm just extracting the simple "true/false" from SurveyKit here, then returning that to the Navigator as I pop this page
          if (result.results[0].results[0].result == BooleanResult.POSITIVE) {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
        },
        showProgress: false,
        task: NavigableTask(
          id: TaskIdentifier(),
          steps: [
            QuestionStep(
              title: '[display drill details]\n[confirm participation:]',
              answerFormat: BooleanAnswerFormat(
                positiveAnswer: 'Yes',
                negativeAnswer: 'No',
                result: BooleanResult.POSITIVE,
              ),
            ),
          ],
        ),
        themeData: Styles.darkCupertinoTheme,
      ),
    );
  }
}
