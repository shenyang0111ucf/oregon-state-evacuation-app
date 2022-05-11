import 'package:evac_app/components/utility/upload_drill_details.dart';
import 'package:evac_app/new_styles.dart';
import 'package:evac_app/presenters/page_presenter.dart';
// import 'package:evac_app/task_displays/task_display_experiment.dart';
import 'package:flutter/material.dart';
// import 'package:evac_app/components/demos/elevation_tests/elevation_tests.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      // theme: Styles.darkTheme,
      theme: NewStyles.lightTheme,
      // home: UploadDrillDetails(),
      home: PagePresenter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
