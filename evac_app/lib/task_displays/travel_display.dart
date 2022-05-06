import 'package:evac_app/models/drill_details/drill_tasks/task_details/travel_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelDisplay extends StatelessWidget {
  const TravelDisplay({
    Key? key,
    required this.travelDetails,
    required this.setTravelResult,
  }) : super(key: key);

  final TravelDetails travelDetails;
  final Function setTravelResult;

  void _launchMapsUrl() async {
    if (travelDetails.mapsLink != null) {
      if (!await launchUrl(Uri.parse(travelDetails.mapsLink!)))
        throw 'Could not launch ${travelDetails.mapsLink}';
    }
  }

  /// This needs much better logic based on the required parameters.
  ///
  /// Specifically, if we're missing either mapImageURL or mapsLink we should be
  /// auto-generating them from the required latitude and longitude (this is why
  /// they are required in the first place).
  ///
  /// Parameters (see TravelDetails):
  // locationName
  // latitude
  // longitude
  // blurb
  // explanation?
  // meetingTime?
  // imageURL?
  // mapImageURL?
  // mapsLink?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(travelDetails.blurb),
                    ),
                    if (travelDetails.mapImageURL != null)
                      GestureDetector(
                        onTap: () {
                          _launchMapsUrl();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19.2),
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(travelDetails.mapImageURL!),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(travelDetails.locationName),
                            )),
                        if (travelDetails.imageURL != null)
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.4),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    clipBehavior: Clip.antiAlias,
                                    child:
                                        Image.network(travelDetails.imageURL!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (travelDetails.explanation != null)
                      Text(travelDetails.explanation!),
                    if (travelDetails.meetingTime != null)
                      Text(
                          'Meeting Time: ${DateFormat.jm().format(travelDetails.meetingTime!)}'),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(CupertinoIcons.back, size: 32),
                    SizedBox(width: 4),
                    Text(
                      'Tasks',
                      style: GoogleFonts.getFont(
                        'Open Sans',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    )
                  ])),
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(CupertinoIcons.check_mark_circled),
        label: Text('I made it here!'),
        onPressed: () {
          setTravelResult();
          Navigator.pop(context);
        },
      ),
    );
  }
}
