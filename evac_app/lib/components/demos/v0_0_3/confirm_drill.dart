import 'package:evac_app/components/evac_app_scaffold_no_app_bar.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class ConfirmDrill extends StatefulWidget {
  const ConfirmDrill({
    Key? key,
    required this.drillConfirmed,
  }) : super(key: key);

  final Function drillConfirmed;
  static const valueKey = ValueKey('ConfirmDrill');

  @override
  _ConfirmDrillState createState() => _ConfirmDrillState();
}

class _ConfirmDrillState extends State<ConfirmDrill> {
  @override
  Widget build(BuildContext context) {
    return EvacAppScaffoldNoAppBar(
      title: 'pre drill survey',
      child: SurveyKit(
        onResult: (SurveyResult result) async {
          await handleConfirmDrill(result);
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

  Future<void> handleConfirmDrill(SurveyResult result) async {
    // if (result is from good exit)
    // if (result says yes to confirm)
    await widget.drillConfirmed();
    return;
  }
}
