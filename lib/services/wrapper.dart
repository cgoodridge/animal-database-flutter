import 'package:flutter/material.dart';
import 'package:omnitrix_database_flutter/main.dart';
import 'package:omnitrix_database_flutter/models/user_model.dart';
import 'package:omnitrix_database_flutter/views/login_screen.dart';
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
