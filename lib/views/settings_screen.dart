import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/services/auth.dart';
import 'package:sanctuary/services/globalVariables.dart';


/// TODO: Add confirmation dialog for logout button
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Container(
      child:
        ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("settings", style: GoogleFonts.bungeeHairline(color: Colors.black, fontSize: 34, fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.only(left:16, top:16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Color(0xffe8e8e8),
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Admin", style: GoogleFonts.sarpanch(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.w300),),
                  ),
                ),
                ListTile(
                  title: Text('Account', style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Device', style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Security', style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                Container(
                  padding: EdgeInsets.only(left:16, top:16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Color(0xffe8e8e8),
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("General", style: GoogleFonts.sarpanch(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.w300),),
                  ),
                ),
                ListTile(
                  title: Text('Notifications', style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Display & Sound', style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Data Usage', style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('About', style: TextStyle(fontSize: 18,color: Colors.black)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),

                Padding(
                  padding: EdgeInsets.only(top:30),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.orange)
                    ),
                    child: Text(
                      'LOGOUT',
                        style: GoogleFonts.montserrat(color: Colors.black, fontSize: 22, fontWeight: FontWeight.normal)
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
