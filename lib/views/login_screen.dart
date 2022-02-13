import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/models/models.dart';
import 'package:sanctuary/services/auth.dart';
import 'package:sanctuary/views/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool passwordToggle = true;
  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            SizedBox(height: 60.0),
            Text("Project Sanctuary", style: GoogleFonts.orbitron(fontWeight: FontWeight.normal, color: Colors.black,fontSize: 36),),
            SizedBox(height: 60.0),
            Image.asset('assets/images/logo.png', width: 200,),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black,),
                            prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) => val.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.black,),
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          suffixIcon: passwordToggle ? IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                passwordToggle = !passwordToggle;
                              });
                            },)
                              :
                          IconButton(
                            icon: Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                passwordToggle = !passwordToggle;
                              });
                            },)
                          ,
                        ),
                        obscureText: passwordToggle,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.orange)
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                              if(result == null) {
                                setState(() {
                                  error = 'Could not sign in with those credentials';
                                });
                              }
                            }
                          }
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        "Forgot Password",
                        style: TextStyle(color: Colors.black, fontSize: 14.0),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(textStyle: TextStyle(color: Colors.black, fontSize: 14.0)),
                        child: const Text("Register"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistrationScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
