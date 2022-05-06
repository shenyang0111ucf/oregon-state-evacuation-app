import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:grocc/styles.dart';

class StyledAlertDialog extends StatelessWidget {
  const StyledAlertDialog({
    Key? key,
    required this.context,
    required this.title,
    required this.subtitle,
    required this.cancelText,
    required this.cancelFunc,
    required this.confirmText,
    required this.confirmFunc,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final String subtitle;
  final String cancelText;
  final Function cancelFunc;
  final String confirmText;
  final Function confirmFunc;

  static const _fontNameDefault = 'Open Sans';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(9.6),
      ),
      actionsPadding: EdgeInsets.only(right: 6.0),
      title: Text(
        title,
        style: GoogleFonts.getFont(
          _fontNameDefault,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 24,
        ),
      ),
      content: Text(
        subtitle,
        style: GoogleFonts.getFont(
          _fontNameDefault,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      actions: [
        (cancelText.isNotEmpty)
            ? TextButton(
                onPressed: () {
                  cancelFunc();
                },
                child: Text(
                  cancelText,
                  style: GoogleFonts.getFont(
                    _fontNameDefault,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              )
            : Container(),
        TextButton(
          onPressed: () {
            confirmFunc();
          },
          child: Text(
            confirmText,
            style: GoogleFonts.getFont(
              _fontNameDefault,
              color: Colors.red,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black)),
        ),
      ],
    );
  }
}
