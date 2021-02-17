//Convert all instance f FirebaseUser to our Uer model
//Advantages: we do't leak any internal type of Firebase to the rest of ur codebase and as
//result the only files in our codebase that import FirebaseAuth is this
// We have completely abstract away FirebaseAuth from thge rest of our code
import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
}
