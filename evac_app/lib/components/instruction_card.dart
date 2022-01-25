import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class InstructionCard extends StatelessWidget {
  const InstructionCard({
    Key? key,
    required this.width,
    required this.index,
    required this.instructionText,
    this.finalCard,
    this.completeDrill,
  }) : super(key: key);

  const InstructionCard.example({
    required this.completeDrill,
    required this.width,
    this.finalCard,
  })  : index = 1,
        instructionText = 'Get to high ground.';

  final double width;
  final int index;
  final String instructionText;
  final bool? finalCard;
  final Function? completeDrill;

  @override
  Widget build(BuildContext context) {
    BuildContext biggerContext = context;
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Colors.white24,
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instruction #${index.toString()}',
                style: Styles.normalText.copyWith(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                    child: Text(
                  instructionText,
                  style: Styles.boldText.copyWith(
                    fontSize: 32,
                  ),
                )),
              ),
              (finalCard != null && finalCard!)
                  ? SizedBox(height: 30)
                  : Container(),
              (finalCard != null && finalCard!)
                  ? Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Complete Drill?'),
                                  content:
                                      Text('This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // call upper level function to stop location tracking, etc, then that function calls:
                                        if (completeDrill != null)
                                          completeDrill!(biggerContext);
                                      },
                                      child: const Text('Yes, Complete'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text('complete drill'),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}
