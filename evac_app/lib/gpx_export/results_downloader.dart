// leaving some code here for when I start on the researcher dashboard

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class ResultsDownloader {
  void downloadResults() async {
    String drillEventID = 'abc';
    Directory appDocDir = await getApplicationDocumentsDirectory();

    FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
    firebase_storage.ListResult result =
        await firebase_storage.FirebaseStorage.instanceFor(app: secondaryApp)
            .ref()
            .child('DrillResults')
            .child(drillEventID)
            .list();
    result.prefixes.forEach((firebase_storage.Reference ref) async {
      firebase_storage.ListResult innerResult =
          await firebase_storage.FirebaseStorage.instanceFor(app: secondaryApp)
              .ref(ref.fullPath)
              .list();
      innerResult.items.forEach((firebase_storage.Reference innerRef) {
        innerRef.writeToFile(File('${appDocDir.path}/${ref.name}'));
      });
    });
  }
}
