import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_essential/services/firebase_auth_service.dart';
import 'package:secret_essential/view_models/sign_in_view_model.dart';

class SignInBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService authService =
        Provider.of<FirebaseAuthService>(context);

    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(authService: authService),
      child: Consumer<SignInViewModel>(
        builder: (_, signInViewModel, __) => SignIn(viewModel: signInViewModel),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  SignIn({@required this.viewModel});

  final SignInViewModel viewModel;

  _showPasswordResetDialog(BuildContext context) {
    String resetEmail;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reset password'),
            content: TextField(
              onChanged: (email) => resetEmail = email,
              decoration: InputDecoration(hintText: "Insert email"),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  viewModel.sendPasswordResetEmail(resetEmail);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: viewModel.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      // Title
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          height: MediaQuery.of(context).size.height * 0.20 +
                              MediaQuery.of(context).padding.top,
                          child: Center(
                            child: SafeArea(
                                child: Text("Secret",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold))),
                          )),
                      SizedBox(
                        height: 30,
                      ),

                      // Email and Password
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: SignInForm(
                          viewModel: viewModel,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //Recover password
                      GestureDetector(
                        onTap: () {
                          _showPasswordResetDialog(context);
                        },
                        child: Text("Password lost? Recover it"),
                      ),

                      // Alternative login
                      SizedBox(
                        height: 40,
                      ),
                      Text("-- OR --"),
                      FlatButton(
                        child: Text("Login with Google"),
                        onPressed: () => viewModel.signInWithGoogle(),
                      ),
                      FlatButton(
                        child: Text("Login with Facebook"),
                        onPressed: null,
                      ),
                      FlatButton(
                        child: Text("Login with Apple"),
                        onPressed: null,
                      ),

                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        viewModel.message,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  )),
      ),
    );
  }
}

// Create a LoginForm widget.
class SignInForm extends StatefulWidget {
  SignInForm({@required this.viewModel});

  final SignInViewModel viewModel;

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  String email;
  String password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            onChanged: (email) => this.email = email,
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
            validator: (email) {
              return widget.viewModel.emailValidator(email);
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            onChanged: (password) => this.password = password,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (password) {
              return widget.viewModel.passwordValidator(password);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    widget.viewModel.register(email, password);
                  }
                },
                child: Text('Register'),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    widget.viewModel
                        .signInWithEmailAndPassword(email, password);
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
