import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class DuringDrill extends StatefulWidget {
  const DuringDrill({
    Key? key,
    required this.drillEvent,
  }) : super(key: key);

  final DrillEvent drillEvent;
  static const valueKey = ValueKey('DuringDrill');

  @override
  _DuringDrillState createState() => _DuringDrillState();
}

class _DuringDrillState extends State<DuringDrill> {
  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
      title: 'example drill',
      child: LayoutBuilder(builder: (BuildContext context, constraints) {
        var height = constraints.maxHeight;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height * 0.4,
              child: Center(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      'complete drill',
                      style: Styles.boldText.copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: height * 0.3,
              child: Container(
                color: Colors.white24,
                child: Container(),
              ),
            ),
            Container(
              height: height * 0.3,
              child: Container(
                color: Colors.white54,
              ),
            ),
          ],
        );
      }),
    );
  }
}
