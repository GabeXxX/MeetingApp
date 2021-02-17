import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/common_widget/avatar.dart';
import 'package:secret_essential/common_widget/multiple-services-as-arguments.dart';
import 'package:secret_essential/models/relation_model.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/routes/routes.dart';
import 'package:secret_essential/services/firebase_auth_service.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';
import 'package:secret_essential/services/firebase_user_data_service.dart';
import 'package:secret_essential/services/search-service.dart';

class Home extends StatelessWidget {
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
    final FirebaseAuthService authService =
        Provider.of<FirebaseAuthService>(context);
    final UserData userData = Provider.of<UserData>(context);
    final FirebaseRelationService relationService =
        Provider.of<FirebaseRelationService>(context);
    final FirebaseUserDataService userDataService =
        Provider.of<FirebaseUserDataService>(context);

    return StreamBuilder<List<Relation>>(
        stream: relationService.relations,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> relationsSnapshot) {
          List<Relation> relationsData = relationsSnapshot.data;

          if (relationsData != null) {
            // TODO sposta logica in view model
            int verifiedsRelation = 0;
            int totalRelations = 0;
            int reputation = 0;
            int partnerIndex = 0;
            int yourIndex = 1;

            for (int i = 0; i < relationsData.length; i++) {
              yourIndex =
                  relationsData[i].partners.indexOf(relationService.userName);
              if (yourIndex == 0)
                partnerIndex = 1;
              else
                partnerIndex = 0;

              if (relationsData[i].isVerified[yourIndex]) {
                totalRelations = totalRelations + 1;
                if (relationsData[i].isVerified[partnerIndex]) {
                  verifiedsRelation = verifiedsRelation + 1;
                  reputation =
                      reputation + relationsData[i].votes[partnerIndex];
                }
              }
            }

            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: DataSearch(relationService, userData));
                  },
                ),
                appBar: AppBar(
                  elevation: 0,
                  title: Text(userData.userName),
                  backgroundColor: Theme.of(context).primaryColor,
                  actions: <Widget>[
                    FlatButton.icon(
                      onPressed: () async {
                        await authService.signOut();
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
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
                                  offset: Offset(
                                      0, 3), // changes position of shadow
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
                                photoUrl: userData.photoUrl,
                                radius: 81,
                                borderRadius: 5,
                                onPressed: () {},
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                userData.name,
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
                                userData.bio,
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
                                    text: "${userData.relational_state} ",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                              color: Colors.white,
                                              fontSize: 18)),
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
                                              color: Colors.white,
                                              fontSize: 18)),
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
                                              color: Colors.white,
                                              fontSize: 18)),
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
                                        context, Routes.relationsPage,
                                        arguments: MultipleServicesAsArguments(
                                            relationService, userData)),
                                    'Relations',
                                    'View your experiences',
                                    Icons.favorite,
                                    context),
                                SizedBox(
                                  height: 20,
                                ),
                                _buildCard(
                                    () => Navigator.pushNamed(
                                        context, Routes.personalInfopage,
                                        arguments: userData),
                                    'Personal info',
                                    'View your personal info',
                                    Icons.import_contacts,
                                    context),
                                SizedBox(
                                  height: 20,
                                ),
                                _buildCard(
                                    () => Navigator.pushNamed(
                                        context, Routes.notifierPage,
                                        arguments: MultipleServicesAsArguments(
                                            relationService, userData)),
                                    'Notifications',
                                    'View your notifications',
                                    Icons.notifications,
                                    context),
                              ],
                            )),
                      ]),
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });

    //Verifieds = where isVerfied[true, true]
    //Total relation = where isVerified[true, false] and isVerfied[true, true] where the first true is the username index
  }
}

class DataSearch extends SearchDelegate<String> {
  final FirebaseRelationService relationService;
  final UserData userData;
  SearchService searchService = SearchService();

  DataSearch(this.relationService, this.userData);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResult(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResult(context);
  }

  Widget _buildResult(BuildContext context) {
    Future<AlgoliaQuerySnapshot> result = searchService.searchUser(query);

    /* return ListView.builder(itemBuilder: (context, index)=> ListTile(
      leading: Icon(Icons.person),
      onTap: (){
        showResults(context);
      },
      title: RichText(text: TextSpan(
        text: suggestionList[index].substring(0, query.length),
        style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold),
        children:[
          TextSpan(
            text: suggestionList[index].substring((query.length)),
            style: TextStyle(
              color: Colors.grey,
            )
          ),
        ] ,
        ),
      )),
      itemCount:  suggestionList.length,
    );*/

    return Column(
      children: <Widget>[
        FutureBuilder(
          future: result,
          builder: (BuildContext context,
              AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
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
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.hits.length,
                      itemBuilder: (context, index) {
                        final AlgoliaObjectSnapshot result =
                            snapshot.data.hits[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(result.data['photoUrl']),
                            backgroundColor: Theme.of(context).accentColor,
                          ),
                          title: Text(result.data['userName']),
                          subtitle: Text(result.data['name']),
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.profilePage,
                            arguments: MultipleDataAsArguments(
                                result.data, userData, relationService),
                          ),
                        );
                      },
                    ),
                  );
                }
            }
          },
        )
      ],
    );
  }
}
