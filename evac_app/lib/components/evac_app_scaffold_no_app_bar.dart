import 'package:flutter/material.dart';

class EvacAppScaffoldNoAppBar extends StatelessWidget {
  const EvacAppScaffoldNoAppBar({
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
      body: SafeArea(child: child),
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
