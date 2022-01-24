import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class InstructionDisplay extends StatelessWidget {
  const InstructionDisplay({
    Key? key,
    required this.drillEvent,
  }) : super(key: key);

  final DrillEvent drillEvent;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
