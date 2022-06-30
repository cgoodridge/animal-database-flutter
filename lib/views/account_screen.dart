import 'package:cloud_firestore/cloud_firestore.dart';
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
  final currentUserUID = FirebaseAuth.instance.currentUser.uid;
  bool editState = false;

  String firstName = '';
  String lastName = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    return Scaffold(
      body: StreamBuilder<CustomUserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (!userAnon) {
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
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )),
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
                            !editState
                                ? ListTile(
                                    title: Text("Account Name"),
                                    subtitle: !userAnon
                                        ? Text(userData.firstName +
                                            " " +
                                            userData.lastName)
                                        : Text("Anonymous"),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          editState = true;
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'First Name',
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              initialValue: userData.firstName,
                                              validator: (val) => val.isEmpty
                                                  ? "Enter a First Name"
                                                  : null,
                                              onChanged: (val) {
                                                setState(() => firstName = val);
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Last Name',
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              initialValue: userData.lastName,
                                              validator: (val) => val.isEmpty
                                                  ? "Enter a Last Name"
                                                  : null,
                                              onChanged: (val) {
                                                setState(() => lastName = val);
                                              },
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              _confirmUpdateUser(context);
                                              editState = false;
                                            },
                                            icon: Icon(Icons.save)),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                editState = false;
                                              });
                                            },
                                            icon: Icon(Icons.close)),
                                      ],
                                    ),
                                  ),
                            Divider(),
                            ListTile(
                              title: Text("Change your password"),
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
                            ListTile(
                              title: Text('Logout',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.red,
                                      // fontSize: 22,
                                      fontWeight: FontWeight.w300)),
                              onTap: () async {
                                _confirmLogout(context);
                              },
                            ),
                          ],
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
            } else {
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
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )),
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
                          Divider(),
                          ListTile(
                              title: Text("Account Name"),
                              subtitle: Text("Anonymous Sign-In")),
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
                          ListTile(
                            title: Text('Logout',
                                style: GoogleFonts.montserrat(
                                    color: Colors.red,
                                    // fontSize: 22,
                                    fontWeight: FontWeight.w300)),
                            onTap: () async {
                              _confirmLogout(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]);
            }
          }),
    );
  }

  void updateUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserUID)
        .update({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  Future<String> _confirmUpdateUser(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Update'),
        content: const Text('Update name?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              updateUser();
              Navigator.pop(context, 'OK');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<String> _confirmLogout(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context, 'OK');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
