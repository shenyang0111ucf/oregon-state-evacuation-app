import 'package:evac_app/components/utility/styled_alert_dialog.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructionCard extends StatelessWidget {
  const InstructionCard({
    Key? key,
    required this.width,
    required this.index,
    required this.instructionText,
    this.finalCard = false,
    this.completeDrill,
  }) : super(key: key);

  const InstructionCard.example({
    required this.completeDrill,
    required this.width,
    this.finalCard = false,
  })  : index = 1,
        instructionText = 'Get to high ground.';

  final double width;
  final int index;
  final String instructionText;
  final bool finalCard;
  final Function? completeDrill;

  @override
  Widget build(BuildContext context) {
    BuildContext biggerContext = context;
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.125 * 0.75 * 0.25),
        child: Container(
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
                  (!finalCard)
                      ? 'Instruction #${(index + 1).toString()}'
                      : 'Final Instruction',
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
                (finalCard) ? SizedBox(height: 30) : Container(),
                (finalCard)
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StyledAlertDialog(
                                    context: context,
                                    title: 'Complete Drill?',
                                    subtitle: 'This action cannot be undone.',
                                    cancelFunc: () {
                                      Navigator.pop(context);
                                    },
                                    cancelText: 'Cancel',
                                    confirmFunc: () {
                                      Navigator.pop(context);
                                      // call upper level function to stop location tracking, etc, then that function calls the `Nav.pop`s
                                      if (completeDrill != null)
                                        completeDrill!(biggerContext, true);
                                    },
                                    confirmText: 'Yes, Complete',
                                  );
                                });
                          },
                          child: Container(
                            height: 45,
                            width: 150,
                            child: Center(
                              child: Text(
                                'Complete Drill',
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          style: Styles.confirmButton.copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.deepOrange[600])),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
