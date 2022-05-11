import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
        title: 'waiting...',
        backButton: false,
        child: Center(
          child: Column(
            children: [
              Text(
                'waiting for drill to begin.',
                style: Styles.boldAccentText,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 80),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ));
  }
}
