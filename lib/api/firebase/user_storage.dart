import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firechat/api/firebase/common_functions.dart';
import 'package:firechat/models/response.dart';
import 'package:uuid/uuid.dart';

class FirebaseUserStorage {

  static final uuid = Uuid();
  
  Reference get userStorage => FirebaseStorage.instance.ref().child("users");

  Future<Response<String>> add(String userId, String filepath) =>
      _callStorage(userId, (storageRef) async {
        final file = File(filepath);
        final result = await storageRef.child(uuid.v1()).putFile(file);
        return await result.ref.getDownloadURL();
      });

  Future<Response<D>> _callStorage<D>(
          String userId, Future<D> Function(Reference) storageCall) =>
      callFirebaseService(() async {
        final userRef = userStorage.child(userId);
        final data = await storageCall(userRef);
        return data;
      });
}
