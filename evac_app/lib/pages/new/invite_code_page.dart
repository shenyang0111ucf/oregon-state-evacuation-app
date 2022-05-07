import 'package:evac_app/components/progress_button.dart';
import 'package:evac_app/components/utility/gradient_background_container.dart';
import 'package:evac_app/components/utility/styled_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Add logo text to bottom:
/// Stack: Align.bottomCenter: Padd.only.bottom(12): LogoText()
///
/// Add invite code f'n'l'ty:
/// Get code from old invite code page
/// Add button to submit
/// calls onInviteCodeEntered
/// need to fully implemnet in page presenter the firestore access
/// also need to implement the DrillResults upload to Cloud Storage
/// also need an UPLOAD_RESULTS task, should popup dialog

class InviteCodePage extends StatefulWidget {
  const InviteCodePage({
    Key? key,
    required this.tryInviteCode,
  }) : super(key: key);

  final Function tryInviteCode;

  @override
  _InviteCodePageState createState() => _InviteCodePageState();
}

Future<void> tryCode(
  BuildContext topContext,
  String inputCode,
  Function tryInviteCode,
) async {
  var success = await tryInviteCode(inputCode);
  if (!success) {
    // pop up error
    await showDialog<void>(
        context: topContext,
        builder: (BuildContext context) {
          return StyledAlertDialog(
            context: context,
            title: 'Error!',
            subtitle:
                'The entered invite code is invalid. Please contact your drill leader.',
            cancelFunc: () {},
            cancelText: '',
            confirmFunc: () {
              Navigator.pop(context);
            },
            confirmText: 'OK',
          );
        });
  }
}

// Widget inviteBuild(BuildContext context, Function tryInviteCode,
//     Function onInviteCodeEntered) {
//   return
// }

class _InviteCodePageState extends State<InviteCodePage> {
  final _formKey = GlobalKey<FormState>();
  String inviteCode = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundContainer(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome Participant',
                style: TextStyle(
                    fontFamily: "Open Sans",
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold)),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 22),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2))
                        ]),
                    width: 300,
                    height: 50,
                    child: TextFormField(
                      // keyboardType: TextInputType.numbe,
                      validator: (value) {
                        final codeExp = RegExp(r'^[0-9]{6}$');
                        if (value != null && codeExp.hasMatch(value)) {
                          return null;
                        } else {
                          showInviteCodeErrorDialog(
                              context, 'Invite codes must be 6 digits');
                          return 'Invite codes must be 6 digits';
                        }
                      },
                      onSaved: (value) => this.inviteCode = value!,
                      // tryCode(
                      //   context,
                      //   value!,
                      //   widget.tryInviteCode,
                      // ),
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          errorStyle: TextStyle(height: 0, fontSize: 0),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 1),
                          // icon: SvgPicture.asset("assets/icons/plus.svg"),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(CupertinoIcons.add),
                          ),
                          iconColor: const Color(0xFFF3643b),
                          hintText: 'Invite code',
                          hintStyle: GoogleFonts.openSans(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 60.0),
                        child: Container(
                          width: 100,
                          height: 40,
                          child: ProgressButton(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            strokeWidth: 2,
                            child: Text(
                              'enter',
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    )
                                  ]),
                            ),
                            onPressed: (AnimationController controller) async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // dismiss keyboard: https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus)
                                  currentFocus.unfocus();
                                if (!_isLoading) {
                                  _isLoading = true;
                                  controller.forward();
                                  await tryCode(
                                    context,
                                    inviteCode,
                                    widget.tryInviteCode,
                                  );
                                  controller.reset();
                                  _isLoading = false;
                                }
                              }
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ]),
    );
  }
}

void showInviteCodeErrorDialog(BuildContext topContext, String message) async {
  await showDialog<void>(
      context: topContext,
      builder: (BuildContext context) {
        return StyledAlertDialog(
          context: context,
          title: 'Error!',
          subtitle: message,
          cancelFunc: () {},
          cancelText: '',
          confirmFunc: () {
            Navigator.pop(context);
          },
          confirmText: 'OK',
        );
      });
}
