import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';

class MultipleServicesAsArguments {
  final FirebaseRelationService relationService;
  final UserData userData;

  FirebaseRelationService get getRelationService {
    return relationService;
  }

  UserData get getUserData {
    return userData;
  }

  MultipleServicesAsArguments(this.relationService, this.userData);
}

class MultipleDataAsArguments {
  final Map<String, dynamic> externalUserData;
  final UserData userData;
  final FirebaseRelationService relationService;

  MultipleDataAsArguments(
      this.externalUserData, this.userData, this.relationService);
}
