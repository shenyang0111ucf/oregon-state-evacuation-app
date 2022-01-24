// elevation_tests.dart

import 'package:evac_app/components/demos/v0_0_2/location_demo.dart';
import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:flutter/material.dart';

class ElevationTests extends StatelessWidget {
  ElevationTests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
      title: 'elevation tests',
      child: LocationDemo(),
    );
  }
}
