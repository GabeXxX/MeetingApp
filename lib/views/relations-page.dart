import 'package:flutter/material.dart';
import 'package:secret_essential/common_widget/multiple-services-as-arguments.dart';
import 'package:secret_essential/models/relation_model.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';
import 'add-relation-page.dart';

class Relations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MultipleServicesAsArguments args =
        ModalRoute.of(context).settings.arguments;
    final FirebaseRelationService relationService = args.getRelationService;
    final UserData userData = args.getUserData;

    void _openAddRelationDialog() {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new AddRelationBuilder(
              relationService: relationService,
              userData: userData,
            );
          },
          fullscreenDialog: true));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Relations"),
      ),
      body: StreamBuilder<List<Relation>>(
        stream: relationService.relations,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> relationsSnapshot) {
          List<Relation> relationsData = relationsSnapshot.data;

          if (relationsData != null) {
            // TODO Visualize relation only if your verified is true -> sposta logica in view model
            List<Relation> relations = [];
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
                print(yourIndex);
                print(relationsData[i].isVerified[yourIndex]);
                relations.add(relationsData[i]);
              }
            }

            return ListView.builder(
              itemCount: relations.length,
              itemBuilder: (BuildContext context, int index) {
                int partnerIndex = 0;
                int yourIndex =
                    relations[index].partners.indexOf(relationService.userName);
                if (yourIndex == 0)
                  partnerIndex = 1;
                else
                  partnerIndex = 0;

                return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      padding: EdgeInsets.only(right: 20),
                    ),
                    key: Key(relations[index].documentId),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        await relationService.deleteRelation(
                            relationId: relations[index].documentId);
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("A relation has been deleted")));
                      }
                    },
                    child: ListTile(
                      title: Text("${relations[index].partners[partnerIndex]}"),
                      trailing: relations[index].isVerified[partnerIndex]
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(Icons.check_circle_outline,
                              color: Colors.grey),
                      subtitle: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: relations[index].votes[partnerIndex] != null
                                  ? "${relations[index].votes[partnerIndex]}/10"
                                  : "Your partner has not rate you yet",
                              style: TextStyle(color: Colors.grey[600])),
                          WidgetSpan(
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ]),
                      ),
                      //Text("vote: ${relations[index].votes[partnerIndex]}/10"),
                      isThreeLine: true,
                    ));
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _openAddRelationDialog();
        },
      ),
    );
  }
}
