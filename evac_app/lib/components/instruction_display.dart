import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:evac_app/components/instruction_card.dart';
import 'package:evac_app/models/drill_event.dart';
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
    return CarouselSlider(items: [
      InstructionCard(
        index: 1,
        instructionText: 'Get to high ground, minimum elevation: 200 ft.',
        width: width,
        completeDrill: completeDrill,
      ),
      InstructionCard(
        index: 2,
        instructionText: 'Complete the drill by pressing the button below.',
        width: width,
        finalCard: true,
        completeDrill: completeDrill,
      ),
    ], options: CarouselOptions(enableInfiniteScroll: false, height: 600));
  }
}
