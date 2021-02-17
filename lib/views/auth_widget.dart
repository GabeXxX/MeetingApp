import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/models/user_model.dart';
import 'package:secret_essential/services/firebase_user_data_service.dart';
import 'package:secret_essential/views/home_builder.dart';
import 'package:secret_essential/views/home_widget.dart';
import 'package:secret_essential/views/sign_in.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.loginUserSnapshot})
      : super(key: key);
  final AsyncSnapshot<User> loginUserSnapshot;

  @override
  Widget build(BuildContext context) {
    //final FirebaseUserDataService userDataService = Provider.of<FirebaseUserDataService>(context);  //qui da errore

    if (loginUserSnapshot.connectionState == ConnectionState.active) {
      if (loginUserSnapshot.hasData) {
        print(loginUserSnapshot.data.uid);
        // final FirebaseUserDataService userDataService = Provider.of<FirebaseUserDataService>(context); qui no -> vedi home_builder per spiegazione
        return HomeBuilder(
          builder: (context, userDataSnapshot) {
            return HomeWidget(userDataSnapshot: userDataSnapshot);
          },
        );
      }
      return SignInBuilder();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
