import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:flutter/material.dart';
import './styles.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: Styles.darkTheme,
      home: EvacAppScaffold(
        title: title,
        child: Center(),
      ),
    );
  }
}
