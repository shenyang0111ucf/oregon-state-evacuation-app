import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:flutter/material.dart';

class InviteCodePage extends StatefulWidget {
  const InviteCodePage({Key? key}) : super(key: key);

  @override
  _InviteCodePageState createState() => _InviteCodePageState();
}

class _InviteCodePageState extends State<InviteCodePage> {
  // TODO: 2: Write a function to validate input

  // TODO: 3: Output any valid input to Snackbar using following snippet:
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text()));

  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
      title: 'invite code page',
      // TODO: 1: create widgets that allow six digits to be input
      child: Container(),
    );
  }
}
