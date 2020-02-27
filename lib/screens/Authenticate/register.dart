import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constant.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;
  String email="";
  String password="";
  String error="";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Text("Sign up in Brew Crew"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              widget.toggleView();
            },
             icon: Icon(
               Icons.person,
               color: Colors.black,
               ),
              label: Text(
                "SignIn",
                style: TextStyle(
                  color: Colors.black,
                ),))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (value) => value.isEmpty ? "Enter a email": null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (value) => value.length < 6 ? "Enter a password 6+ chars long":null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                onPressed: () async {
                  if(_formkey.currentState.validate())
                  {
                    setState(() {
                      loading = true;
                    });
                    dynamic user = await _auth.registerWithEmailAndPassword(email, password);
                    if(user == null){
                      setState(() {
                        loading = false;
                        error = "please enter a valid email";
                      });
                    }
                  }
                },
                color: Colors.pink,
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              ),
              SizedBox(height: 20.0,),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}