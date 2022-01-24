import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  LandingPage({
    Key? key,
    required this.tryInviteCode,
  }) : super(key: key);

  final Function tryInviteCode;
  static const valueKey = ValueKey('LandingPage');

  @override
  Widget build(BuildContext context) {
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
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.4,
                    maxHeight: MediaQuery.of(context).size.height * 0.5),
                padding: EdgeInsets.only(left: 28.8, bottom: 48, right: 28.8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 19.2),
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
                        padding: EdgeInsets.only(top: 19.2),
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
                        height: 48,
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
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 62.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.6),
                                    color: Colors.white),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            left: 28.8, right: 28.8),
                                        child: FittedBox(
                                            child: Text(
                                          "Enter Invite Code",
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black),
                                        ))
                                        //})),
                                        )))
                          ])
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
