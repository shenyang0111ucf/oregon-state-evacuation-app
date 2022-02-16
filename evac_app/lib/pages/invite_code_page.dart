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
  final _formKey = GlobalKey<FormState>();
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
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                final codeExp = RegExp(r'^[0-9]{6}$');
                if (value != null && codeExp.hasMatch(value)) {
                  return null;
                } else {
                  return 'error: code must be 6 digits';
                }
              },
              onSaved: (value) => _tryCode(context, value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Invite Code',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate())
                    _formKey.currentState!.save();
                },
                child: Text('enter')),
          ]),
        ),
      ),
    );
  }

  Future<void> _tryCode(BuildContext context, inputCode) async {
    var success = await widget.tryInviteCode(inputCode);
    if (!success) {
      // pop up error
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error!'),
              content: const Text(
                  'The entered invite code is invalid. Please contact your drill leader.'),
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
  }
}
