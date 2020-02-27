import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/Authenticate/Authenticate.dart';
import 'package:brew_crew/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final dynamic user = Provider.of<User>(context);
    
    if(user == null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}
