import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evac_app/styles.dart';

class LandingPage extends StatelessWidget {
  LandingPage({
    Key? key,
    required this.pushInviteCodePage,
  }) : super(key: key);

  final Function pushInviteCodePage;
  static const valueKey = ValueKey('LandingPage');

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    // print('height:\t$pageHeight');
    // print('width: \t$pageWidth');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/coast.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(
                  left: pageWidth * 0.07,
                  bottom: pageHeight * (0.055 + 0.0759),
                  right: pageWidth * 0.07,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: pageHeight * 0.0235),
                        child: Text(
                          'Evacuation Drill Simulator App',
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: pageHeight * 0.0235),
                        child: Text(
                          'The goal of this app is to help gather data to better prepare the Oregon Coastal Community in the event of an emergency.',
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: pageHeight * 0.059,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FittedBox(
                                    child: Text(
                                      'Are you ready?',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: pageWidth * 0.07,
                                right: pageWidth * 0.07,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  pushInviteCodePage();
                                },
                                style: Styles.button,
                                child: SizedBox(
                                  height: 62.4,
                                  child: Center(
                                    child: Text(
                                      "Enter Invite Code",
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
