import 'package:flutter/material.dart';
import 'package:secret_essential/models/relation_model.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';

class ExternalUserRelationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> externalUserData =
        ModalRoute.of(context).settings.arguments;
    Future<List<Relation>> relations =
        FirebaseRelationService.getExternalUserRelations(
            externalUserData["userName"]);

    return Scaffold(
        appBar: AppBar(
          title: Text("Relations"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder(
              future: relations,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Relation>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                    break;
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Relation> relationsData = snapshot.data;

                      if (relationsData != null) {
                        // TODO Visualize relation only if your verified is true -> sposta logica in view model
                        List<Relation> relations = [];
                        int partnerIndex = 0;
                        int externalUserIndex = 1;
                        for (int i = 0; i < relationsData.length; i++) {
                          externalUserIndex = relationsData[i]
                              .partners
                              .indexOf(externalUserData["userName"]);
                          if (externalUserIndex == 0)
                            partnerIndex = 1;
                          else
                            partnerIndex = 0;

                          if (relationsData[i].isVerified[externalUserIndex]) {
                            print(externalUserIndex);
                            print(
                                relationsData[i].isVerified[externalUserIndex]);
                            relations.add(relationsData[i]);
                          }
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: relations.length,
                            itemBuilder: (context, index) {
                              int partnerIndex = 0;
                              int externalUserIndex = relations[index]
                                  .partners
                                  .indexOf(externalUserData["userName"]);
                              if (externalUserIndex == 0)
                                partnerIndex = 1;
                              else
                                partnerIndex = 0;

                              return ListTile(
                                trailing:
                                    relations[index].isVerified[partnerIndex]
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(Icons.check_circle_outline,
                                            color: Colors.grey),
                                title: Text(
                                    relations[index].partners[partnerIndex]),
                                subtitle: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: relations[index]
                                                    .votes[partnerIndex] !=
                                                null
                                            ? "${relations[index].votes[partnerIndex]}/10"
                                            : "Partner has not rate this relation yet",
                                        style:
                                            TextStyle(color: Colors.grey[600])),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ]),
                                ), //Text("vote
                              );
                            },
                          ),
                        );
                      }
                    }
                }
              },
            )
          ],
        ));
  }
}
