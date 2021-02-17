import 'package:flutter/material.dart';
import 'package:secret_essential/models/user_data_model.dart';

class ExternalUserPreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> tmp = ModalRoute.of(context).settings.arguments;
    tmp["reputation"] = tmp["reputation"].toDouble();

    UserData userData = UserData.fromJson(tmp);

    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListTile(
                key: Key(userData.userName),
                title: Text("User name: ${userData.userName}"),
              ),
              ListTile(
                key: Key(userData.name),
                title: Text("Name: ${userData.name}"),
              ),
              ListTile(
                key: Key(userData.birthday),
                title: Text(
                    "Birthday: ${userData.birthday.substring(0, userData.birthday.indexOf("T"))}"),
              ),
              ListTile(
                key: Key(userData.place),
                title: Text("Place: ${userData.place}"),
              ),
              ListTile(
                key: Key(userData.genre),
                title: Text("Genre: ${userData.genre}"),
              ),
              ListTile(
                key: Key(userData.relational_state),
                title: Text("State: ${userData.relational_state}"),
              ),
              ListTile(
                key: Key(userData.bio),
                title: Text("Biography: ${userData.bio}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
