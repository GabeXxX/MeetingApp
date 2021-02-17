import 'package:flutter/material.dart';
import 'package:secret_essential/common_widget/multiple-services-as-arguments.dart';
import 'package:secret_essential/models/relation_model.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO sposta stream con relativo snapshot ad un livello superiore in modo che sia dispnibile sia a notifier che a relations
    final MultipleServicesAsArguments args =
        ModalRoute.of(context).settings.arguments;
    final FirebaseRelationService relationService = args.getRelationService;
    final UserData userData = args.getUserData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Notifications"),
      ),
      body: StreamBuilder<List<Relation>>(
        stream: relationService.relations,
        builder:
            (BuildContext context, AsyncSnapshot<dynamic> relationsSnapshot) {
          List<Relation> relationsData = relationsSnapshot.data;

          if (relationsData != null) {
            // TODO Visualize relation only if your verified is FALSE -> sposta logica in view model
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

              if (!relationsData[i].isVerified[yourIndex]) {
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

                return Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          trailing: Icon(Icons.person),
                          title: Text(
                              "${relations[index].partners[partnerIndex]}"),
                          subtitle: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${relations[index].votes[partnerIndex]}/10",
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
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text("Verify"),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) {
                                    return RateDialog(
                                      relation: relations[index],
                                      yourIndex: yourIndex,
                                      relationService: relationService,
                                    );
                                  }),
                            ),
                            /*FlatButton(
                              child: Text("Dismiss"),
                              onPressed: () {
                                relationService.updateRelation(relationId: relations[index].partners, partners: null, votes: null, isVerified: null)
                              },
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("There aren't new notifications"),
            );
          }
        },
      ),
    );
  }
}

class RateDialog extends StatefulWidget {
  final FirebaseRelationService relationService;
  final Relation relation;
  final int yourIndex;

  const RateDialog(
      {Key key, this.relation, this.yourIndex, this.relationService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RateDialogState();
  }
}

class RateDialogState extends State<RateDialog> {
  double _currentSliderValue = 6;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate you partner'),
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Slider(
            activeColor: Colors.amber,
            value: _currentSliderValue,
            min: 0,
            max: 10,
            divisions: 10,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
          Container(
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 80 + _currentSliderValue * 5,
                ),
                Text(
                  _currentSliderValue.floor().toString(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      )),
      actions: <Widget>[
        FlatButton(
          child: Text('Rate!'),
          onPressed: () {
            List<int> votes = widget.relation.votes;
            votes[widget.yourIndex] = _currentSliderValue.floor();
            widget.relationService.updateRelation(
                relationId: widget.relation.documentId,
                partners: widget.relation.partners,
                votes: votes,
                isVerified: [true, true]);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
