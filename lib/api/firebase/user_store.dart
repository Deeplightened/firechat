import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firechat/api/error_codes.dart';
import 'package:firechat/api/firebase/common_functions.dart';
import 'package:firechat/common/configuration/logger.dart';
import 'package:firechat/models/user_profile.dart';
import 'package:firechat/models/response.dart';

class FirebaseUserStore {
  CollectionReference get store =>
      FirebaseFirestore.instance.collection("users");

  Future<Response<String>> createNew(UserProfile user) => callFirebaseService(() async {
        await store.doc(user.id).set(user.toJson());
        return user.id;
      });

  Future<Response<bool>> update(
          String userId, Map<String, dynamic> userValues) =>
      callFirebaseService(() async {
        await store.doc(userId).update(userValues);
        return true;
      });

  Future<Response<UserProfile>> get(String userId)  =>
      callFirebaseService(() async {
        final response = await store.doc(userId).get();
        if (!response.exists) throw Exception("A user should exists at this point");

        return UserProfile.fromJson(response.data());
      });

  Stream<UserProfile> listen(String userId) {
    return store.doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserProfile.fromJson(snapshot.data());
    });
  }
}
