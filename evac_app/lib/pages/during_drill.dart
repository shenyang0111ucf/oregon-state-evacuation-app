import 'dart:async';
import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/components/instruction_display.dart';
import 'package:evac_app/location_tracking/location_tracker.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/models/drill_stopwatch.dart';
import 'package:evac_app/models/instructions/instructions.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class DuringDrill extends StatefulWidget {
  DuringDrill({
    Key? key,
    required this.drillEvent,
    required this.userID,
  }) : super(key: key);

  final DrillEvent drillEvent;
  final String userID;
  static const valueKey = ValueKey('DuringDrill');
  final DateTime startDateTime = DateTime.now();

  @override
  _DuringDrillState createState() => _DuringDrillState();
}

class _DuringDrillState extends State<DuringDrill> {
  var showColors = false;

  double? distance;
  int? elevation;
  // String representation of time elapsed
  String minutesStr = '00', secondsStr = '00';
  DrillStopwatch stopwatch = DrillStopwatch();
  late StreamSubscription stopwatchSubscription;

  LocationTracker locTracker = LocationTracker();

  @override
  void initState() {
    super.initState();

    // start stopwatch
    stopwatchSubscription = stopwatch.getStream().listen((int counter) {
      setState(() {
        minutesStr = ((counter / 60).floor() % 60).toString().padLeft(2, '0');
        secondsStr = (counter % 60).toString().padLeft(2, '0');
      });
    });

    // start tracking location
    locTracker.startLogging();
  }

  void completeDrill(BuildContext context) async {
    // create gpxFile
    final gpxFileNameFuture = locTracker.createTrajectory(widget.userID);

    // stop tracking location
    await locTracker.stopLogging();

    // cancel stopwatch stream subscription
    stopwatchSubscription.cancel();

    Map<String, dynamic> results = {
      'result': true,
      'gpxFileNameFuture': gpxFileNameFuture,
    };

    // pop navigator
    Navigator.pop(context, results);
  }

  @override
  Widget build(BuildContext context) {
    var bigContext = context;
    void confirmEndDrillEarly() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Wait!'),
          content: const Text(
              'Are you sure that you want to exit the drill early? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // pop dialog
                Navigator.pop(context);
              },
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                // stop tracking location
                // async generate .gpx
                // pop dialog
                Navigator.pop(context);
                // pop during drill page
                Navigator.pop(bigContext, {'result': false});
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      );
    }

    return EvacAppScaffold(
      title: 'example drill',
      backButton: true,
      backButtonFunc: confirmEndDrillEarly,
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
                instructions: Instructions.fromJson(
                    widget.drillEvent.duringDrillInstructionsJSON),
              ),
            ),
            Container(
              height: height * 0.25,
              color: showColors ? Colors.white12 : null,
              child: Center(
                child: Text(
                  '$minutesStr:$secondsStr',
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
                          locTracker.distanceTravelled.toStringAsFixed(2),
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
                          '~' + locTracker.currentElevation.toString(),
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
