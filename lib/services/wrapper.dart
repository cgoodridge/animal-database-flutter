import 'package:flutter/material.dart';
import 'package:sanctuary/main.dart';
import 'package:sanctuary/models/user_model.dart';
import 'package:sanctuary/views/login_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //Return either home or login widget

    if (user == null)
    {
      return LoginScreen();
    }
    else
    {
      return MyHomePage();
    }
  }
}
