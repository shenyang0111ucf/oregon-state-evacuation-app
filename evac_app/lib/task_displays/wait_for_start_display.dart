import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitForStartDisplay extends StatelessWidget {
  const WaitForStartDisplay({Key? key, required this.pushPerformDrill})
      : super(key: key);

  final Function pushPerformDrill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                  pushPerformDrill();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
