import 'package:flutter/foundation.dart';

class Relation {
  const Relation(
      {@required this.partners,
      @required this.votes,
      @required this.isVerified,
      this.documentId});

  factory Relation.fromJson(Map<String, dynamic> snapshot, String documentId) {
    return Relation(
      partners: List.from(snapshot["partners"]),
      votes: List.from(snapshot["votes"]),
      isVerified: List.from(snapshot["isVerified"]),
      documentId: documentId,
    );
  }

  Map<String, dynamic> toJson() => {
        'isVerified': this.isVerified,
        'votes': this.votes,
        'partners': this.partners,
      };

  final List<String> partners;
  final List<int> votes;
  final List<bool> isVerified;
  final String documentId;
}
