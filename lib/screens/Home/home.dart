import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/Home/brew_list.dart';
import 'package:brew_crew/screens/Home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/services/database.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(
        context: context,
         builder: (context){
           return Container(
             padding: EdgeInsets.symmetric(horizontal:60.0,vertical:20.0),
             child: SettingsForm(),
           );
         });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Brew Crew"),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
              icon: Icon(
                Icons.person,
                color: Colors.black,
                ),
              label: Text(
                "logout",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
                ),
              label: Text(
                "settings",
                style: TextStyle(color: Colors.black),
                ),
                onPressed: () => _showSettingsPanel(),
            ),
        ],
      ),
      body: BrewList(),
    ),
  );
  }
}
