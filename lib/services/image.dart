import 'dart:io';
import 'dart:typed_data';

import 'package:firebase/models/category.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> cleanImageCache() async {
    Directory applicationDir = await getApplicationDocumentsDirectory();
    DateTime deleteBeforeDate =
        DateTime.now().subtract(imageCacheRetentionPeriod);

    applicationDir
        .list()
        .where((FileSystemEntity file) => p.extension(file.path) == '.jpg')
        .where((FileSystemEntity img) =>
            img.statSync().changed.isBefore(deleteBeforeDate))
        .forEach((img) => img.deleteSync());
  }

  Future<String?> storeImage({
    required String uid, // AuthUser uid
    required Category category,
    required String localPath, // camera path
  }) async {
    String filename = remoteImageFilename(uid); // remote image name with ext

    try {
      await _storage
          .ref(category.name)
          .child(filename)
          .putFile(File(localPath))
          .timeout(awaitTimeout);
    } catch (e) {
      return null;
    }

    return filename;
  }

  Future<void> _storeImageLocal(
    Uint8List data,
    String category,
    String filename, // remote image filename
  ) async {
    Directory deviceStoragePath = await getApplicationDocumentsDirectory();
    String localPath =
        '${deviceStoragePath.path}/${category}_$filename'; // image on local environment

    await File(localPath).writeAsBytes(data);

    return;
  }

  Future<Uint8List?> _retrieveImageLocal(
    String category,
    String imageFilename,
  ) async {
    Directory deviceStoragePath = await getApplicationDocumentsDirectory();
    File localPath =
        File('${deviceStoragePath.path}/${category}_$imageFilename');

    if (await localPath.exists()) {
      return await localPath.readAsBytes();
    } else {
      return null;
    }
  }

  Future<Image?> retrieveImage({
    required String category,
    required String imageFilename,
  }) async {
    try {
      Uint8List? imageData;

      imageData = await _retrieveImageLocal(category, imageFilename);

      if (imageData == null) {
        imageData = await _storage
            .ref(category)
            .child(imageFilename)
            .getData()
            .timeout(awaitTimeout);

        if (imageData != null) {
          _storeImageLocal(imageData, category, imageFilename);
        }
      }

      return imageData == null ? null : Image.memory(imageData);
    } catch (e) {
      return null;
    }
  }
}
