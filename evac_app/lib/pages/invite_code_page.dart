import 'package:flutter/material.dart';
import 'package:evac_app/components/evac_app_scaffold.dart';

class InviteCodePage extends StatefulWidget {
  const InviteCodePage({Key? key}) : super(key: key);

  @override
  State<InviteCodePage> createState() => _InviteCodePageState();
}

class _InviteCodePageState extends State<InviteCodePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
      title: "invite code page",
      child: Container(
        child: TextField(
          controller: _controller,
          onSubmitted: (String value) async {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                final codeExp = RegExp(r'^[0-9]{6}$');
                if (codeExp.hasMatch(value)) {
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: Text('Thank you for joining us with code $value!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
                return AlertDialog(
                  title: const Text('Error!'),
                  content: const Text('Invite code is 6 digital.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Invite Code',
          ),
        ),
      ),
    );
  }
}
