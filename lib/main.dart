import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/routes/routes.dart';
import 'package:secret_essential/services/firebase_auth_service.dart';
import 'package:secret_essential/views/external-user-preferences-page.dart';
import 'package:secret_essential/views/external-user-relation-page.dart';
import 'package:secret_essential/views/notification-page.dart';
import 'package:secret_essential/views/auth_widget.dart';
import 'package:secret_essential/views/auth_widget_builder.dart';
import 'package:secret_essential/views/personal-info-page.dart';
import 'package:secret_essential/views/relations-page.dart';
import 'package:secret_essential/views/user-profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Multiprovider must be above the material app -> all widget have access to it
      providers: [
        Provider<FirebaseAuthService>(
            create: (context) => FirebaseAuthService()),
      ],
      child: AuthWidgetBuilder(builder: (context, userSnapshot) {
        return MaterialApp(
          title: 'Secret essential',
          theme: ThemeData(
            fontFamily: 'Raleway',
            brightness: Brightness.light,
            primaryColor: Colors.redAccent[400],
            accentColor: Colors.deepPurpleAccent,
          ),
          home: AuthWidget(loginUserSnapshot: userSnapshot),
          routes: {
            Routes.relationsPage: (context) => Relations(),
            Routes.personalInfopage: (context) => PersonaInfo(),
            Routes.notifierPage: (context) => NotificationPage(),
            Routes.profilePage: (context) => UserProfile(),
            Routes.relationProfilePage: (context) => ExternalUserRelationPage(),
            Routes.preferencesProfilePage: (context) =>
                ExternalUserPreferencesPage(),
          },
        );
      }),
    );
  }
}
