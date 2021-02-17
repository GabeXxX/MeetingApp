import 'package:flutter/foundation.dart';

@immutable
class UserData {
  const UserData(
      {this.name,
      this.userName = null,
      this.birthday = null,
      this.genre = null,
      this.place = null,
      this.relational_state = null,
      this.photoUrl = null,
      this.bio = null,
      this.numberOfRelations = null,
      this.reputation = null,
      @required this.isFirstLogin});

  factory UserData.fromJson(Map<String, dynamic> snapshot) {
    return UserData(
        name: snapshot["name"],
        userName: snapshot["userName"],
        birthday: snapshot["birthday"],
        genre: snapshot["genre"],
        place: snapshot["place"],
        relational_state: snapshot["relational_state"],
        photoUrl: snapshot["photoUrl"],
        bio: snapshot["bio"],
        numberOfRelations: snapshot["numberOfRelations"],
        reputation: snapshot["reputation"],
        isFirstLogin: snapshot["isFirstLogin"]);
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'userName': this.userName,
        'birthday': this.birthday,
        'genre': this.genre,
        'place': this.place,
        'relational_state': this.relational_state,
        'bio': this.bio,
        'numberOfRelations': this.numberOfRelations,
        'photoUrl': this.photoUrl,
        'isFirstLogin': this.isFirstLogin,
        'reputation': this.reputation,
      };

  final String name;
  final String userName;
  final String birthday;
  final String genre;
  final String place;
  final String relational_state;
  final String photoUrl;
  final String bio;
  final int numberOfRelations;
  final double reputation;
  final bool isFirstLogin;
}
