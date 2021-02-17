import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/models/avatar_reference.dart';
import 'package:secret_essential/services/firebase_storage_service.dart';
import 'package:secret_essential/services/firebase_user_data_service.dart';
import 'package:secret_essential/services/image_picker_service.dart';
import 'package:flutter/foundation.dart';

class AccountConfigurationViewModel extends ChangeNotifier {
  AccountConfigurationViewModel(
      {@required this.imagePickerService,
      @required this.storageService,
      @required this.userDataService});

  final ImagePickerService imagePickerService;
  final FirebaseStorageService storageService;
  final FirebaseUserDataService userDataService;
  bool isLoading = false;
  String message = "";

  String photoUrl = "";
  String name = "";
  String userName = "";
  String birthday = DateTime.now().toIso8601String();
  String genre = "";
  String relational_state = "";
  String bio = "";
  final formKey = GlobalKey<FormState>();

  Future<void> chooseAvatar() async {
    try {
      isLoading = true;
      notifyListeners();
      // 1. Get image from ImagePicker
      final file =
          await imagePickerService.pickImage(source: ImageSource.gallery);
      if (file != null) {
        // 2. Upload to Firebase Storage
        this.photoUrl = await storageService.uploadAvatar(file: file);
        // 3. Save url to Firestore(database
        await userDataService
            .setAvatarReference(AvatarReference(this.photoUrl));
        // 4. (optional) delete local file as no longer needed
        await file.delete();
      }
    } catch (e) {
      isLoading = false;
      message = e.toString();
      print(e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateUserData() async {
    try {
      if (formKey.currentState.validate()) {
        print(name);
        isLoading = true;
        await userDataService.updateUserData(
            name: this.name,
            userName: this.userName,
            birthday: this.birthday,
            bio: this.bio,
            photoUrl: this.photoUrl,
            genre: this.genre,
            relational_state: this.relational_state,
            reputation: 0.0,
            numberOfRelations: 0,
            place: null);
        notifyListeners();
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
