import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitFirstDialogContent extends StatelessWidget {
  const WaitFirstDialogContent(this.topContext,
      {Key? key, required this.taskTitle})
      : super(key: key);

  final BuildContext topContext;
  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.hand_raised,
          size: 128,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          'Hold on!',
          style: GoogleFonts.getFont(
            'Open Sans',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'You need to complete "$taskTitle" task first!',
          style: GoogleFonts.getFont(
            'Open Sans',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        CupertinoButton.filled(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(topContext);
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
