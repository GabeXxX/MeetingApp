import 'package:flutter/material.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';

class RelationViewModel extends ChangeNotifier {
  bool isLoading = false;
  String message = "";
  String partnerName = "";
  String userName = "";
  int vote = 6;
  final formKey = GlobalKey<FormState>();
  final FirebaseRelationService relationService;
  final UserData userData;

  RelationViewModel({@required this.relationService, @required this.userData});

  Future<void> addRelation() async {
    try {
      if (formKey.currentState.validate()) {
        isLoading = true;
        notifyListeners();
        userName = userData.userName;
        List<String> partners = [userName, this.partnerName];
        List<int> votes = [vote, null];
        List<bool> isVerified = [true, false];
        return relationService.addRelation(
            partners: partners, votes: votes, isVerified: isVerified);
      }
    } catch (e) {
      isLoading = false;
      message = e.toString();
      print(e.toString());
      notifyListeners();
      rethrow;
    }
  }
}
