import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  LandingPage({
    Key? key,
    required this.tryInviteCode,
  }) : super(key: key);

  final Function tryInviteCode;
  static const valueKey = ValueKey('LandingPage');

  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
        title: 'landing page',
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                          content: Text(
                              'should eventually link to "Website Explaining Research"')));
                  },
                  child: Text(
                    "tell me more about this app",
                  )),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () {
                      tryCode(context);
                    },
                    child: Text(
                      "[enter valid invite code]",
                    ));
              }),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ));
  }

  Future<void> tryCode(BuildContext context) async {
    // freeze interaction with:
    //   submit button
    //   edit numbers
    // show loading popup
    // verify invite code and get secondary research details
    var success = await tryInviteCode();
    if (!success) {
      // Validation Popup
    }
  }
}
