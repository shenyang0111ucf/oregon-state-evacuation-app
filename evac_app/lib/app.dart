import 'package:evac_app/pages/during_drill.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:flutter/material.dart';
import 'package:evac_app/presenters/basic_drill_presenter.dart';
import 'package:evac_app/styles.dart';
// import 'package:evac_app/components/demos/elevation_tests/elevation_tests.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: Styles.darkTheme,
      home: DuringDrill(
        drillEvent: DrillEvent.example(),
      ),
      // home: ElevationTests(),
    );
  }
}
