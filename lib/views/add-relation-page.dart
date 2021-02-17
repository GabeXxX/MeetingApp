import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/services/firebase_relations_service.dart';
import 'package:secret_essential/view_models/add-relation-view-model.dart';

class AddRelationBuilder extends StatelessWidget {
  final FirebaseRelationService relationService;
  final UserData userData;

  const AddRelationBuilder(
      {Key key, @required this.relationService, @required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RelationViewModel>(
      create: (_) => RelationViewModel(
          relationService: relationService, userData: userData),
      child: Consumer<RelationViewModel>(
          builder: (_, relationViewModel, __) =>
              AddRelationDialog(relationViewModel: relationViewModel)),
    );
  }
}

class AddRelationDialog extends StatelessWidget {
  final RelationViewModel relationViewModel;

  const AddRelationDialog({Key key, @required this.relationViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('New relation'),
        actions: [
          new FlatButton(
              onPressed: () async {
                await relationViewModel.addRelation();
                Navigator.pop(context);
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
              )),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                relationViewModel.isLoading
                    ? AlertDialog(
                        title: Text("Adding relation..."),
                        content: LinearProgressIndicator())
                    : RelationForm(
                        relationViewModel: relationViewModel,
                      ),
              ],
            )),
      ),
    );
  }
}

// Define a custom Form widget.
class RelationForm extends StatefulWidget {
  final RelationViewModel relationViewModel;

  const RelationForm({Key key, @required this.relationViewModel})
      : super(key: key);

  @override
  RelationFormState createState() {
    return RelationFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class RelationFormState extends State<RelationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  double _currentSliderValue = 6;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: widget.relationViewModel.formKey,
        child: Column(children: <Widget>[
          TextFormField(
            onChanged: (name) => {widget.relationViewModel.partnerName = name},
            decoration: InputDecoration(
              labelText: "User name",
              icon: Icon(Icons.person),
              //prefixIcon: Icon(Icons.email),
            ),
            validator: (name) {
              if (name.isEmpty) return "Insert a name";
              return null;
            },
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            onChanged: (name) => {},
            decoration: InputDecoration(
              labelText: "Duration",
              icon: Icon(Icons.timer),
              //prefixIcon: Icon(Icons.email),
            ),
            validator: (time) {
              return null;
            },
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            onChanged: (name) => {},
            decoration: InputDecoration(
              labelText: "Date",
              icon: Icon(Icons.calendar_today),
              //prefixIcon: Icon(Icons.email),
            ),
            validator: (date) {
              return null;
            },
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            onChanged: (name) => {},
            decoration: InputDecoration(
              labelText: "Location",
              icon: Icon(Icons.map),
              //prefixIcon: Icon(Icons.email),
            ),
            validator: (loc) {
              return null;
            },
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            maxLines: 3,
            onChanged: (comment) => {},
            decoration: InputDecoration(
              labelText: "Other comment",
              icon: Icon(Icons.assignment),
              //prefixIcon: Icon(Icons.email),
            ),
            validator: (comment) {
              return null;
            },
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Rate you partner!",
            style: TextStyle(),
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
                widget.relationViewModel.vote = _currentSliderValue.floor();
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
        ]));
  }
}
