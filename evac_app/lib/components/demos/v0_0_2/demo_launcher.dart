import 'package:evac_app/components/demos/v0_0_2/location_demo.dart';
import 'package:evac_app/components/demos/v0_0_2/ui_ux_demo.dart';
import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/components/evac_app_scaffold_no_app_bar.dart';
import 'package:flutter/material.dart';

class DemoLauncher extends StatelessWidget {
  const DemoLauncher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EvacAppScaffold(
      title: 'demo launcher',
      child: Center(
        child: ElevatedButton(
          child: Text('start survey'),
          onPressed: () {
            // print('hmm');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EvacAppScaffold(
                    title: 'location demo', child: LocationDemo())));
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EvacAppScaffoldNoAppBar(
                    title: 'ui ux demo', child: UiUxDemo())));
          },
        ),
      ),
    );
  }
}
