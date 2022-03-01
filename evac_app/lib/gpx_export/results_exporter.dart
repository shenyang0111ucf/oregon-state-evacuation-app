import 'dart:io';

import 'package:evac_app/gpx_export/encode_files.dart';
import 'package:evac_app/models/drill_result.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class ResultsExporter {
  String drillEventID;
  String publicKey;
  DrillResult drillResult;
  String userID;

  ResultsExporter({
    required this.drillEventID,
    required this.publicKey,
    required this.drillResult,
    required this.userID,
  });

  Future<void> export() async {
    // create relevant files
    final preDrillPlain = await _createJsonFile(preDrill: true);
    final postDrillPlain = await _createJsonFile(preDrill: false);
    final preDrillCipher = await _encodeFile(publicKey, preDrillPlain);
    final postDrillCipher = await _encodeFile(publicKey, postDrillPlain);
    final gpxCipher = await _encodeFile(publicKey, drillResult.getGpxFile());

    await _uploadFile(preDrillCipher, '/preDrillSurveyResult.json.enc');
    await _uploadFile(postDrillCipher, '/postDrillSurveyResult.json.enc');
    await _uploadFile(gpxCipher, '/${userID}.gpx.enc');
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

  Future<File> _createJsonFile({required bool preDrill}) async {
    final directory = await getApplicationDocumentsDirectory();
    var exists = Directory('${directory.path}/jsonFiles/').existsSync();
    if (!exists) {
      Directory('${directory.path}/jsonFiles/').createSync();
    }
    final result = (preDrill)
        ? drillResult.printPreDrillResult()
        : drillResult.printPostDrillResult();

    // does not specify results for drill/user id
    // haphazard, please rearchitect
    final filename =
        (preDrill) ? 'preDrillSurveyResult' : 'postDrillSurveyResult';
    var file = File('${directory.path}/jsonFiles/${filename}.json');
    if (file.existsSync()) file.deleteSync();

    file.writeAsStringSync(result);
    return file;
  }
}
