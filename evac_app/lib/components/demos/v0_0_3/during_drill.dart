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
      child: Center(
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
    );
  }
}
