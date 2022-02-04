import 'package:flutter/material.dart';
import 'package:evac_app/components/evac_app_scaffold.dart';

class InviteCodePage extends StatefulWidget {
  const InviteCodePage({
    Key? key,
    required this.tryInviteCode,
  }) : super(key: key);

  static const valueKey = ValueKey('InviteCodePage');
  final Function tryInviteCode;

  @override
  State<InviteCodePage> createState() => _InviteCodePageState();
}

class _InviteCodePageState extends State<InviteCodePage> {
  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
      title: "invite code page",
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 20.0,
        ),
        child: Container(
          child: TextField(
            onSubmitted: (String value) async {
              final codeExp = RegExp(r'^[0-9]{6}$');
              if (codeExp.hasMatch(value)) {
                _tryCode(context, value);
              } else {
                await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error!'),
                        content: const Text('Invite code should be 6 digits.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Invite Code',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tryCode(BuildContext context, inputCode) async {
    var success = await widget.tryInviteCode(inputCode);
    if (!success) {
      // pop up error
    }
  }
}
