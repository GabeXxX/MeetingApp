import 'package:flutter/material.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/views/first_configuration.dart';
import 'package:secret_essential/views/home-page.dart';
import 'package:secret_essential/views/sign_in.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({@required this.userDataSnapshot});

  final AsyncSnapshot<UserData> userDataSnapshot;

  @override
  Widget build(BuildContext context) {
    // comunque questo non è nulla che non possa fare all'interno di un unico widget, invece di dividerlo in home_builder e home_widget
    if (userDataSnapshot.connectionState == ConnectionState.active) {
      if (userDataSnapshot.hasData) {
        // da qui in poi tutti i discendenti hanno accesso al provider userData
        if (userDataSnapshot.data.isFirstLogin) {
          return FirstConfigurationBuilder();
        }
        return Home();
      }

      return Scaffold(
        //TODO: fix userDataSnapshot has no data
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ); //Home();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
