import 'dart:io';

import 'package:evac_app/gpx_export/encode_files.dart';
import 'package:evac_app/models/drill_result.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class ResultExporter {
  String drillEventID;
  String publicKey;
  DrillResult drillResult;
  String userID;

  ResultExporter({
    required this.drillEventID,
    required this.publicKey,
    required this.drillResult,
    required this.userID,
  });

  Future<void> export() async {
    // create relevant files
    final resultsPlain = await _createJsonFile();
    if (resultsPlain == null) {
      throw Exception('results were not ready to export');
    }

    final resultsCipher = await _encodeFile(publicKey, resultsPlain);
    final gpxCipher = await _encodeFile(publicKey, drillResult.getGpxFile());

    await _uploadFile(resultsCipher, '/$userID-results.json.enc');
    await _uploadFile(gpxCipher, '/$userID.gpx.enc');
  }

  Future<void> _uploadFile(File file, String filePath) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('DrillResults')
        .child(drillEventID)
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
    final result = drillResult.exportSurveyResultsToJsonString();

    if (result == null) {
      return null;
    }

    // does not specify results for drill/user id
    // haphazard, please rearchitect
    var file = File('${directory.path}/jsonFiles/results.json');
    if (file.existsSync()) file.deleteSync();

    file.writeAsStringSync(result);
    return file;
  }
}
