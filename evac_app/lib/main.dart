import 'package:evac_app/db/trajectory_database_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await TrajectoryDatabaseManager.initialize();
  runApp(App(title: 'title'));
}
