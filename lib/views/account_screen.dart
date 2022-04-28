import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/models/user_model.dart';
import 'package:sanctuary/services/database.dart';
import 'package:provider/provider.dart';
import 'package:sanctuary/views/settings_screen.dart';

import '../services/auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _auth = AuthService();
  final userAnon = FirebaseAuth.instance.currentUser.isAnonymous;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    return Scaffold(
      body: StreamBuilder<CustomUserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CustomUserData userData = snapshot.data;
              return Column(children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 40,
                            ),
                          ),
                          Flexible(
                              child: Text(
                            "Account",
                            style: GoogleFonts.bungeeHairline(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),

                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: IconButton(
                          //     color: Colors.black,
                          //     icon: !isSearching ? Icon(Icons.search) : Icon(Icons.cancel),
                          //     onPressed: () {
                          //       // Expand search Field
                          //       setState(() {
                          //         isSearching = !isSearching;
                          //       });
                          //     },
                          //   ),
                          // )

                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 32,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Text("Account Name"),
                            subtitle: !userAnon
                                ? Text(userData.firstName +
                                    " " +
                                    userData.lastName)
                                : Text("Anonymous"),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {},
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Account Name"),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Settings"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsScreen()),
                              );
                            },
                          ),
                          Divider(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.orange)),
                          child: Text('LOGOUT',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            await _auth.signOut();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            } else {
              return Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
