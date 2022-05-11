import 'dart:io';

import 'package:evac_app/export/encode_files.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ResultsExporter {
  String publicKey;
  DrillResults drillResults;
  String userID;

  ResultsExporter({
    required this.drillResults,
  })  : publicKey = drillResults.publicKey,
        userID = drillResults.userID;

  Future<void> export() async {
    // create relevant results file
    final resultsPlain = await _createJsonFile();
    if (resultsPlain == null) {
      throw Exception('results were not ready to export');
    }

    final resultsCipher = await _encodeFile(publicKey, resultsPlain);
    await _uploadFile(resultsCipher, '/$userID-results.json.enc');

    // pull gpx file names into list
    drillResults.assembleGpxFilesList();

    for (var gpx in drillResults.gpxFiles) {
      if (File(gpx).existsSync()) {
        final gpxPlain = File(gpx);
        final gpxCipher = await _encodeFile(publicKey, File(gpx));
        await _uploadFile(gpxCipher, basename(gpxPlain.path) + '.enc');
      }
    }
  }

  Future<void> _uploadFile(File file, String filePath) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('DrillResults')
        .child(drillResults.drillID)
        .child(userID)
        .child(filePath)
        .putFile(file);
  }

  Future<File> _encodeFile(String publicKey, File plaintextFile) async {
    final newFilePath = await EncodeFiles()
        .encodeRSA(filePath: plaintextFile.path, pubKeyString: publicKey);
    return File(newFilePath);
  }

  Future<File?> _createJsonFile() async {
    final directory = await getApplicationDocumentsDirectory();
    var exists = Directory('${directory.path}/jsonFiles/').existsSync();
    if (!exists) {
      Directory('${directory.path}/jsonFiles/').createSync();
    }
    final result = drillResults.toJson();

    // does not specify results for drill/user id
    // haphazard, please rearchitect
    var file = File(
        '${directory.path}/jsonFiles/${drillResults.userID}_${drillResults.drillID}.json');
    if (file.existsSync()) file.deleteSync();

    file.writeAsStringSync(result.toString());
    return file;
  }
}
