import 'package:flutter/material.dart';
import 'package:evac_app/components/evac_app_scaffold.dart';

class InviteCodePage extends StatelessWidget {
  const InviteCodePage({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: InviteCodePageWidget(),
    );
  }
}

class InviteCodePageWidget extends StatefulWidget {
  const InviteCodePageWidget({Key? key}) : super(key: key);

  @override
  State<InviteCodePageWidget> createState() => _InviteCodePageWidgetState();
}

class _InviteCodePageWidgetState extends State<InviteCodePageWidget> {
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
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value)));
                  return AlertDialog(
                    title: const Text('Thanks!'),
                    content: const Text('Thank you for joining us!'),
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
