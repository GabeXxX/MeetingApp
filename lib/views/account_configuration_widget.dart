import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/common_widget/avatar.dart';
import 'package:intl/intl.dart';
import 'package:secret_essential/models/user_data_model.dart';
import 'package:secret_essential/view_models/account_configuration_view_model.dart';

class AccountConfigurationWidget extends StatelessWidget {
  AccountConfigurationWidget({@required this.viewModel});

  final AccountConfigurationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    String photoUrl = Provider.of<UserData>(context, listen: false).photoUrl;

    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: photoUrl,
          radius: 60,
          onPressed: () => viewModel.chooseAvatar(),
        ),
        Text(
          "Click to insert a profile picture",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        ConfigForm(
          viewModel: viewModel,
        ),
      ],
    );
  }
}

// Create a LoginForm widget.
class ConfigForm extends StatefulWidget {
  ConfigForm({@required this.viewModel});

  final AccountConfigurationViewModel viewModel;

  @override
  ConfigFormState createState() {
    return ConfigFormState();
  }
}

class ConfigFormState extends State<ConfigForm> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();
  TextEditingController _genre = new TextEditingController();
  TextEditingController _states = new TextEditingController();
  var genres = ["Male", "Female"];
  var states = ["Single", "Engaged", "Open relationship"];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.value =
            TextEditingValue(text: DateFormat('yyyy-MM-dd').format(picked));
        widget.viewModel.birthday = picked.toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = widget.viewModel.formKey;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            onChanged: (name) => widget.viewModel.name = name,
            decoration: InputDecoration(
              labelText: "Name*",
              //prefixIcon: Icon(Icons.email),
            ),
            validator: (name) {
              if (name.isEmpty) return "Insert a name";
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onChanged: (userName) => widget.viewModel.userName = userName,
            decoration: InputDecoration(
              labelText: "User name*",
              //prefixIcon: Icon(Icons.lock),
            ),
            validator: (userName) {
              if (userName.isEmpty) return "Insert an user name";
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _date,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Birthday*',
                ),
                validator: (date) {
                  if (date.isEmpty) return "Insert a date";
                  return null;
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            validator: (genre) {
              if (genre.isEmpty) return "insert a genre";
              return null;
            },
            readOnly: true,
            controller: _genre,
            decoration: InputDecoration(
              labelText: 'Genre*',
              hintText: "Select a genre from menù",
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (String value) {
                  _genre.text = value;
                  widget.viewModel.genre = value;
                },
                itemBuilder: (BuildContext context) {
                  return genres.map<PopupMenuItem<String>>((String value) {
                    return new PopupMenuItem(
                        child: new Text(value), value: value);
                  }).toList();
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            validator: (state) {
              if (state.isEmpty) return "insert a state";
              return null;
            },
            readOnly: true,
            controller: _states,
            decoration: InputDecoration(
              labelText: 'Relational state*',
              hintText: "Select a state from menù",
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (String value) {
                  _states.text = value;
                  widget.viewModel.relational_state = value;
                },
                itemBuilder: (BuildContext context) {
                  return states.map<PopupMenuItem<String>>((String value) {
                    return new PopupMenuItem(
                        child: new Text(value), value: value);
                  }).toList();
                },
              ),
            ),
          ),
          TextFormField(
            maxLines: 5,
            onChanged: (bio) => widget.viewModel.bio = bio,
            decoration: InputDecoration(
              labelText: "Biography",
              //prefixIcon: Icon(Icons.lock),
            ),
            //validator: () {},
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: <Widget>[
              Text("*Obligatory"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
