import 'package:evac_app/components/utility/styled_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitForStartDisplay extends StatelessWidget {
  const WaitForStartDisplay(
      {Key? key,
      required this.pushPerformDrill,
      required this.setWaitForStartResult})
      : super(key: key);

  final Function pushPerformDrill;
  final Function setWaitForStartResult;

  // TODO: Add exit button
  //  on exit: setWaitForStartResult(false);

  @override
  Widget build(BuildContext context) {
    final topContext = context;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'You\'re all set to perform your drill, whenever you\'re ready 👍',
                    style: GoogleFonts.getFont(
                      'Roboto',
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 36,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CupertinoButton.filled(
                  child: Text('Let\'s get started!'),
                  onPressed: () {
                    setWaitForStartResult(true);
                    pushPerformDrill();
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StyledAlertDialog(
                          context: context,
                          title: 'Exit to Tasks?',
                          subtitle:
                              'You will not be able to start performing the drill from that menu.',
                          cancelText: 'Keep Waiting',
                          cancelFunc: () {
                            Navigator.pop(context);
                          },
                          confirmText: 'Exit to Tasks',
                          confirmFunc: () {
                            setWaitForStartResult(false);
                            Navigator.pop(context);
                            Navigator.pop(topContext);
                          });
                    });
              },
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(CupertinoIcons.back, size: 32),
                    SizedBox(width: 4),
                    Text(
                      'Tasks',
                      style: GoogleFonts.getFont(
                        'Roboto',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    )
                  ])),
            ),
          ),
        ]),
      ),
    );
  }
}
