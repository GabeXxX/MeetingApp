import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:secret_essential/models/avatar_reference.dart';
import 'package:secret_essential/models/user_data_model.dart';

import 'firestore_path.dart';

class FirebaseUserDataService {
  FirebaseUserDataService({@required this.uid});

  final String uid;
  final CollectionReference _usersCollection =
      Firestore.instance.collection("user_data");

  // De-serialize from json
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData.fromJson(snapshot.data);
  }

  //Read
  Stream<UserData> get userData {
    return _usersCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //Create
  Future<void> createOnfirstLoginUserData() async {
    UserData userData = UserData(isFirstLogin: true);
    return await _usersCollection.document(uid).setData(userData.toJson());
  }

  //Update
  Future<void> updateUserData(
      {@required String name,
      @required String userName,
      @required String birthday,
      @required String genre,
      @required String place,
      @required String relational_state,
      @required String photoUrl,
      @required String bio,
      @required int numberOfRelations,
      @required double reputation}) async {
    UserData userData = UserData(
        isFirstLogin: false,
        name: name,
        userName: userName,
        birthday: birthday,
        genre: genre,
        place: place,
        relational_state: relational_state,
        photoUrl: photoUrl,
        bio: bio,
        numberOfRelations: numberOfRelations,
        reputation: reputation);

    return await _usersCollection.document(uid).updateData(userData.toJson());
  }

  //Delete
  Future<void> deleteUserData() async {
    return await _usersCollection.document(uid).delete();
  }

  // Sets the avatar download url
  Future<void> setAvatarReference(AvatarReference avatarReference) async {
    final path = FirestorePath.avatar(uid); //TODO: refactor without path
    final reference = Firestore.instance.document(path);
    await reference.updateData(
      avatarReference.toMap(),
    );
  }

  // Reads the current avatar photo url
  Stream<AvatarReference> avatarReferenceStream() {
    final path = FirestorePath.avatar(uid);
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => AvatarReference.fromMap(snapshot.data));
  }
}
