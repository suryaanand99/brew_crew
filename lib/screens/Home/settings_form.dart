import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constant.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formkey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    final dynamic user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        if(snapshot.hasData){

          UserData userData = snapshot.data;

          return Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text(
                  "Update your brew settings",
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration.copyWith(hintText:"Name"),
                  validator: (value) => value.isEmpty ? "PLease enter a name" : null,
                  onChanged: (value) {
                    setState(() {
                      _currentName = value;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? userData.sugars,
                  items: sugars.map((sugar){
                    return DropdownMenuItem<String>(
                      value: sugar,
                      child: Text("$sugar sugar(s)"),
                      );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _currentSugars = value;
                    });
                  },
                  ),
                SizedBox(height: 20.0,),
                Slider(
                  activeColor: Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor: Colors.brown[_currentStrength ??userData.strength],
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (value) {
                    setState(() {
                      _currentStrength = value.round();
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    "Update",
                    style: TextStyle(color:Colors.white),
                  ),
                  onPressed: () async {
                    if(_formkey.currentState.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars ?? userData.sugars,
                        _currentName ?? userData.name,
                        _currentStrength ?? userData.strength
                        );
                        Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          );
        }else{
          return Loading();
        }

      }
    );
  }
}