import 'package:evac_app/components/instruction_card.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class InstructionDisplay extends StatelessWidget {
  const InstructionDisplay({
    Key? key,
    required this.drillEvent,
    required this.completeDrill,
    required this.width,
  }) : super(key: key);

  final DrillEvent drillEvent;
  final Function completeDrill;
  final double width;

  // populate dynamic list of InstructionCards w/ DrillEvent.example()
  // put list into SingleChildScrollView
  // put spacers inbetween
  @override
  Widget build(BuildContext context) {
    // need to find a way to have the scroll click into center of each InstructionCard
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SizedBox(width: width * 0.125),
        InstructionCard(
          index: 1,
          instructionText: 'Get to high ground, minimum elevation: 200 ft.',
          width: width,
          completeDrill: completeDrill,
        ),
        SizedBox(width: width * 0.125 * 0.75),
        InstructionCard(
          index: 2,
          instructionText:
              'Very long instruction text. So long in fact, that it will need to be scrollable to be read. Hopefully we can write more succinct instructions for the real drills, but perhaps not…',
          width: width,
          completeDrill: completeDrill,
        ),
        SizedBox(width: width * 0.125 * 0.75),
        InstructionCard(
          index: 3,
          instructionText: 'Complete the drill by pressing the button below.',
          width: width,
          finalCard: true,
          completeDrill: completeDrill,
        ),
        SizedBox(width: width * 0.125),
      ],
    );
  }
}
