import 'package:flutter/material.dart';

class EvacAppScaffold extends StatelessWidget {
  const EvacAppScaffold({
    Key? key,
    required this.title,
    required this.child,
    this.endDrawer,
    this.fAB,
    this.backButton,
    this.backButtonFunc,
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget? endDrawer;
  final FloatingActionButton? fAB;
  final bool? backButton;
  final Function? backButtonFunc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle!
              .copyWith(letterSpacing: 3.0),
        ),
        leading: (backButton != null && backButton!)
            ? BackButton(onPressed: () {
                if (backButtonFunc != null) {
                  backButtonFunc!();
                }
                // Navigator.of(context).pop();
              })
            : null,
        automaticallyImplyLeading:
            (backButton != null && !backButton!) ? false : true,
      ),
      body: SafeArea(
        child: child,
      ),
      endDrawer: endDrawer,
      floatingActionButton: (fAB != null)
          ? Builder(
              builder: (context) {
                return fAB!;
              },
            )
          : null,
    );
  }
}
