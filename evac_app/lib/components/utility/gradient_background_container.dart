import 'package:flutter/material.dart';

class GradientBackgroundContainer extends StatelessWidget {
  const GradientBackgroundContainer({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xF2F3643b),
              Color(0xD9F3643b),
              Color(0x99F09841),
              Color(0x80F3643b),
            ]),
      ),
      child: child,
    );
  }
}
