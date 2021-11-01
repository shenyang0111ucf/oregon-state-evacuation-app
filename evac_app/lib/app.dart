import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:flutter/material.dart';
import './styles.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool? _running;

  @override
  void initState() {
    _running = false;
    super.initState();
  }

  void toggleRunning() {
    // TODO: call toggle to service

    setState(() {
      _running = !_running!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: Styles.darkTheme,
      home: EvacAppScaffold(
        title: widget.title,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              runningToggleButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget runningToggleButton(BuildContext context) {
    return ElevatedButton(
      child: SizedBox(
        child: Text(
          (_running!) ? 'Stop' : 'Start',
          textAlign: TextAlign.center,
        ),
        width: 60,
      ),
      onPressed: toggleRunning,
    );
  }
}
