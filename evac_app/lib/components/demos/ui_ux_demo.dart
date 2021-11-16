import 'package:evac_app/styles.dart';
import 'package:flutter/material.dart';

class UiUxDemo extends StatefulWidget {
  const UiUxDemo({Key? key}) : super(key: key);

  @override
  _UiUxDemoState createState() => _UiUxDemoState();
}

class _UiUxDemoState extends State<UiUxDemo> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'here we go.',
          style: Styles.boldAccentText,
        ),
      ],
    ));
  }
}
