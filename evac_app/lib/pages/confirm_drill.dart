import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class ConfirmDrill extends StatefulWidget {
  const ConfirmDrill({
    Key? key,
    required this.drillEvent,
  }) : super(key: key);

  final DrillEvent drillEvent;
  static const valueKey = ValueKey('ConfirmDrill');

  @override
  _ConfirmDrillState createState() => _ConfirmDrillState();
}

class _ConfirmDrillState extends State<ConfirmDrill> {
  @override
  Widget build(BuildContext context) {
    // TODO: rebuild this without surveykit
    return EvacAppScaffold(
        title: 'confirm drill details',
        child: Column(
          children: [
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 24.0,
              ),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 0.0,
                  ),
                  child: Text(
                    'Is this the drill you want to participate in?',
                    style: Styles.normalText.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(9.6),
                ),
              ),
            ),
            SizedBox(height: 80),
            Column(
              children: [
                Text(
                  widget.drillEvent.meetingLocationPlainText!,
                  style: Styles.boldText.copyWith(fontSize: 36),
                ),
                SizedBox(height: 12),
                Text(
                  widget.drillEvent.meetingDateTime!.month.toString() +
                      '/' +
                      widget.drillEvent.meetingDateTime!.day.toString() +
                      '/' +
                      widget.drillEvent.meetingDateTime!.year.toString(),
                  style: Styles.normalText.copyWith(fontSize: 32),
                ),
                SizedBox(height: 12),
                Text(
                  (widget.drillEvent.meetingDateTime!.hour % 12).toString() +
                      ':' +
                      widget.drillEvent.meetingDateTime!.minute.toString() +
                      ((widget.drillEvent.meetingDateTime!.hour <= 12)
                          ? ' AM'
                          : ' PM'),
                  style: Styles.normalText.copyWith(fontSize: 32),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    '"Description of drill, written by researchers when forming drill details."',
                    style: Styles.normalText
                        .copyWith(fontSize: 24, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            SizedBox(height: 72),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: SizedBox(
                    height: 62.4,
                    width: 62.4 * 3 / 2,
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: Styles.boldText.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  style: Styles.button.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amber[600]),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: SizedBox(
                    height: 62.4,
                    child: Center(
                      child: Text(
                        'Yes, that\'s my drill!',
                        style: Styles.boldText.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  style: Styles.confirmButton,
                ),
              ],
            )
          ],
        ));
  }
}
