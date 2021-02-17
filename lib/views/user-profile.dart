import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:secret_essential/common_widget/avatar.dart';
import 'package:secret_essential/common_widget/multiple-services-as-arguments.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/routes/routes.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';

import 'add-relation-page.dart';

class UserProfile extends StatelessWidget {
  Widget _buildCard(Function onTap, String title1, String subtitle1,
      IconData icon, BuildContext context) {
    return Container(
      height: 100,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.grey[200],
          elevation: 10,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  trailing: Icon(
                    icon,
                    size: 30,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(title1, style: TextStyle(color: Colors.black)),
                  subtitle:
                      Text(subtitle1, style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    MultipleDataAsArguments arg = ModalRoute.of(context).settings.arguments;
    Map<String, dynamic> userData = arg.externalUserData;
    UserData myUserData = arg.userData;
    FirebaseRelationService relationService = arg.relationService;

    int verifiedsRelation = 0;
    int totalRelations = 0;
    int reputation = 0;

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new AddRelationBuilder(
                        relationService: relationService,
                        userData: myUserData,
                      );
                    },
                    fullscreenDialog: true,
                  ));
                },
                label: Text('Add a relation with ${userData["userName"]}'),
                icon: Icon(
                  Icons.favorite,
                ),
              ),
              /* FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.chat_bubble),
            )*/
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          title: Text(userData["userName"]),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(children: <Widget>[
                // Red rounded backgorund
                Container(
                  height: 380,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      // Avatar and user data
                      Avatar(
                        photoUrl: userData["photoUrl"],
                        radius: 81,
                        borderRadius: 5,
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        userData["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userData["bio"],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "${userData["relational_state"]} ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.people,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              // Relations data
                              Text(
                                "Relations",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("${totalRelations}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "Verifieds",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("${verifiedsRelation}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "Reputation",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("${reputation}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        _buildCard(
                            () => Navigator.pushNamed(
                                  context,
                                  Routes.relationProfilePage,
                                  arguments: userData,
                                ),
                            'Relations',
                            "View ${userData["userName"]}'s experiences",
                            Icons.favorite,
                            context),
                        SizedBox(
                          height: 20,
                        ),
                        _buildCard(
                            () => Navigator.pushNamed(
                                  context,
                                  Routes.preferencesProfilePage,
                                  arguments: userData,
                                ),
                            'Partner preferences',
                            "View ${userData["userName"]}'s preferences",
                            Icons.import_contacts,
                            context),
                      ],
                    )),
              ]),
            )));
  }
}
