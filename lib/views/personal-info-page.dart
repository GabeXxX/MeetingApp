import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secret_essential/models/user_data_model.dart';


class PersonaInfo extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    UserData userData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Personal Info"),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: (){
            },
          )
        ],*/
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
                title: Text("Birthday: ${userData.birthday.substring(0, userData.birthday.indexOf("T"))}"),
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
      )
    );
  }

}