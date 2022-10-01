import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFilemodified(
      String filepath, String fileName, Uint8List binaryImage) async {
    File file = File(filepath);
    try {
      await storage
          .ref('test/$fileName')
          .putData(binaryImage)
          .then((p0) => print("binary image uploaded"));
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadFile(String filepath, String fileName) async {
    File file = File(filepath);
    try {
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
//Todo:
//1. Make a future builder.
//2. Return all files
//3. segregate files on bases on modifiedImage

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      print("Found file: $ref");
    });
    print(results.items);

    return results;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('test/$imageName').getDownloadURL();
    return downloadURL;
  }
}
