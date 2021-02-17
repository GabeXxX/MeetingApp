import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';
import 'package:secret_essential/services/firebase_user_data_service.dart';

class HomeBuilder extends StatelessWidget {
  HomeBuilder({@required this.builder});

  final Widget Function(BuildContext, AsyncSnapshot<UserData>) builder;

  @override
  Widget build(BuildContext context) {
    final FirebaseUserDataService userDataService =
        Provider.of<FirebaseUserDataService>(context);

    return StreamBuilder<UserData>(
      stream: userDataService.userData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> userDataSnapshot) {
        UserData userData = userDataSnapshot.data;

        if (userData != null) {
          return MultiProvider(
            providers: [
              // Il builder (home_widget lo avrà a disposzione solo se userData!=null
              // all'interno del builder ci sarà un controllo userDataSnapshot != null che se verificato
              // implicherà che userData!=null e che quindi questo provider è disponibile ai suoi widget discendenti
              Provider<UserData>.value(value: userData),
              Provider<FirebaseRelationService>(
                create: (context) =>
                    FirebaseRelationService(userName: userData.userName),
              ),
            ],
            child: builder(context, userDataSnapshot),
          );
        }
        return builder(context, userDataSnapshot);
      },
    );
  }
}
