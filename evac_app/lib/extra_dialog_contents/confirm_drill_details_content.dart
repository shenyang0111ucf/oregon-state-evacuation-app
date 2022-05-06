import 'package:evac_app/models/drill_details/drill_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ConfirmDrillDetailsContent extends StatelessWidget {
  const ConfirmDrillDetailsContent({
    Key? key,
    required this.onDrillConfirmed,
    required this.drillDetails,
    required this.pageSizeHeight,
  }) : super(key: key);

  final Function onDrillConfirmed;
  final DrillDetails? drillDetails;
  final double pageSizeHeight;

  @override
  Widget build(BuildContext context) {
    if (drillDetails == null) {
      throw Exception('can\'t confirm drill if no drill details');
    }
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(
        double.infinity,
        pageSizeHeight * 0.6,
      )),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Please confirm the following Drill Details are correct:',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Title:  ',
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(text: drillDetails!.title),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Meeting Location:  ',
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: drillDetails!.meetingLocationPlainText,
                      )
                    ],
                  )),
            ),
            if (drillDetails!.blurb != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Purpose:  ',
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(text: drillDetails!.blurb!),
                      ],
                    )),
              ),
            if (drillDetails!.meetingDateTime != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Meeting Date:  ',
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                            text: DateFormat.yMMMMd('en_US')
                                .format(drillDetails!.meetingDateTime!)
                                .toString()),
                      ],
                    )),
              ),
            if (drillDetails!.meetingDateTime != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Meeting Time:  ',
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                            text: DateFormat.jm()
                                .format(drillDetails!.meetingDateTime!)
                                .toString()),
                      ],
                    )),
              ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton.filled(
                  child: const Text('confirm'),
                  onPressed: () => onDrillConfirmed(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
