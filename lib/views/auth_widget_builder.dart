import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/models/user_model.dart';
import 'package:secret_essential/services/firebase_auth_service.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';
import 'package:secret_essential/services/firebase_storage_service.dart';
import 'package:secret_essential/services/firebase_user_data_service.dart';
import 'package:secret_essential/services/image_picker_service.dart';

// Used to create user-dependant objects that need to be accessible by all widgets.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    return StreamBuilder<User>(
      // asynchronos data in
      stream: authService.onAuthStateChanged,
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> loginUserSnapshot) {
        final User user = loginUserSnapshot.data;

        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<User>.value(value: user),
              // other service that need for example user.uid
              // lo hanno a disposizione solo se user!=null. Altrimenti se cerco di prendere FirebaseUserDataSrvice con Provider.of
              // in AuthWidget (builder), il context non avrà accesso a questo provider!
              Provider<FirebaseUserDataService>(
                create: (context) => FirebaseUserDataService(uid: user.uid),
              ),
              Provider<FirebaseStorageService>(
                create: (context) => FirebaseStorageService(uid: user.uid),
              ),
              Provider<ImagePickerService>(
                create: (context) => ImagePickerService(),
              ),
            ],
            child: builder(context, loginUserSnapshot), //MaterialApp
          );
        }
        return builder(context, loginUserSnapshot);
      },
    );
  }
}
// HomePage and all descendant widgets can get the current user with `Provider.of<User>(context, listen: false)`,
// rather than `await FirebaseAuth.instance.currentUser()`
// Note the listen:false. The StreamBuilder in that file already cause the page to rebuild when the user change
// We want to avoi to much rebuild
