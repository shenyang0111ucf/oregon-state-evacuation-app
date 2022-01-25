import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/components/instruction_display.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class DuringDrill extends StatefulWidget {
  DuringDrill({
    Key? key,
    required this.drillEvent,
  }) : super(key: key);

  final DrillEvent drillEvent;
  static const valueKey = ValueKey('DuringDrill');
  final DateTime startDateTime = DateTime.now();
  // TODO: create stream for timer

  @override
  _DuringDrillState createState() => _DuringDrillState();
}

class _DuringDrillState extends State<DuringDrill> {
  var showColors = false;

  double? distance;
  int? elevation;

  // TODO: track location

  // TODO: calculate distance travelled

  // TODO: round elevation

  // TODO: on drill completed:
  void completeDrill(BuildContext context) {
    // stop tracking location
    // async generate .gpx
    // pop navigator
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
      title: 'example drill',
      child: LayoutBuilder(builder: (BuildContext context, constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: height * .034),
            Container(
              height: height * (0.55 - .034),
              child: InstructionDisplay(
                width: width,
                completeDrill: completeDrill,
                drillEvent: widget.drillEvent,
              ),
            ),
            Container(
              height: height * 0.25,
              color: showColors ? Colors.white12 : null,
              child: Center(
                child: Text(
                  '23:45',
                  style: Styles.timerText,
                ),
              ),
            ),
            Container(
              height: height * 0.2,
              color: showColors ? Colors.white24 : null,
              child: Row(
                children: [
                  Container(
                    width: width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // worried that walking icon is ableist, or insensitive
                            // but still probably a better icon choice out there than "redo"
                            Icon(Icons.redo_rounded),
                            SizedBox(width: 8),
                            Text(
                              'Distance',
                              style: Styles.duringDrillDashLabel,
                            ),
                          ],
                        ),
                        Text(
                          '0.89',
                          style: Styles.duringDrillDashData,
                        ),
                        Text(
                          'mi',
                          style: Styles.duringDrillDashLabel,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    color: showColors ? Colors.white24 : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.landscape_rounded),
                            SizedBox(width: 8),
                            Text(
                              'Elevation',
                              style: Styles.duringDrillDashLabel,
                            ),
                          ],
                        ),
                        Text(
                          '~' + '80',
                          style: Styles.duringDrillDashData,
                        ),
                        Text(
                          'ft',
                          style: Styles.duringDrillDashLabel,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
