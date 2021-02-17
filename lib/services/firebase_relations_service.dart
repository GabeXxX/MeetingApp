import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_essential/models/relation_model.dart';

class FirebaseRelationService {
  FirebaseRelationService({@required this.userName});

  final String userName; //userName not user.uid
  static final CollectionReference _relationsCollection =
      Firestore.instance.collection("relations");

  List<Relation> _relationFromSnapshot(QuerySnapshot snapshot) {
    List<DocumentSnapshot> documents = snapshot.documents;
    List<Relation> relations = [];
    for (var doc in documents) {
      relations.add(Relation.fromJson(doc.data, doc.documentID));
    }
    return relations;
  }

  Stream<List<Relation>> get relations {
    return _relationsCollection
        .where("partners", arrayContains: userName)
        .snapshots()
        .map(_relationFromSnapshot);
  }

  Future<void> addRelation(
      {@required List<String> partners,
      @required List<int> votes,
      @required List<bool> isVerified}) async {
    Relation relation =
        Relation(isVerified: isVerified, votes: votes, partners: partners);
    return await _relationsCollection.document().setData(relation.toJson());
  }

  Future<void> updateRelation(
      {@required String relationId,
      @required List<String> partners,
      @required List<int> votes,
      @required List<bool> isVerified}) async {
    Relation relation =
        Relation(isVerified: isVerified, votes: votes, partners: partners);
    return await _relationsCollection
        .document(relationId)
        .updateData(relation.toJson());
  }

  Future<void> deleteRelation({@required String relationId}) async {
    return await _relationsCollection.document(relationId).delete();
  }

  static Future<List<Relation>> getExternalUserRelations(
      String externalUserName) {
    return _relationsCollection
        .where("partners", arrayContains: externalUserName)
        .getDocuments()
        .then((QuerySnapshot snap) {
      List<Relation> result = [];
      for (var doc in snap.documents) {
        result.add(Relation.fromJson(doc.data, doc.documentID));
      }
      return result;
    });
  }
}
