import 'dart:io';

import 'package:evac_app/export/cryptography/rsa_implementation.dart';

class EncodeFiles {
  Future<String> encodeRSA(
      {required String filePath, required pubKeyString}) async {
    final publicKey = RSAimplement.rsaPublicKeyFromPem(pubKeyString);

    var file = File(filePath);

    String newFilePath = filePath + '.enc';
    var newFile = File(newFilePath);
    if (newFile.existsSync()) newFile.deleteSync();

    newFile.writeAsBytesSync(
        RSAimplement.rsaEncrypt(publicKey, file.readAsBytesSync()),
        flush: true);

    return newFilePath;
  }

  Future<void> decodeRSA(
      {required String filePath, required privKeyString}) async {
    final privateKey = RSAimplement.rsaPrivateKeyFromPem(privKeyString);

    var file = File(filePath);

    String newFilePath;
    if (filePath.contains('.enc', -4)) {
      newFilePath = filePath.split('.enc')[0];
    } else {
      newFilePath = filePath + '.dec';
    }
    var newFile = File(newFilePath);
    if (newFile.existsSync()) newFile.deleteSync();

    newFile.writeAsBytesSync(
        RSAimplement.rsaDecrypt(privateKey, file.readAsBytesSync()),
        flush: true);

    return;
  }
}
