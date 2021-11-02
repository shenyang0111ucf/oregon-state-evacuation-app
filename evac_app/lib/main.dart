import 'package:evac_app/db/trajectory_database_manager.dart';
import 'package:flutter/material.dart';

import './app.dart';

void main() async {
  await TrajectoryDatabaseManager.initialize();
  runApp(App(title: 'title'));
}
