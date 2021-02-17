import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omnitrix_database_flutter/services/auth.dart';
import 'package:omnitrix_database_flutter/services/globalVariables.dart';


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
      backgroundColor: Color(0xff2C2C2C),
      body: Container(
      child:
        ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("settings", style: GoogleFonts.bungeeHairline(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),),
                ),
                Container(
                  padding: EdgeInsets.only(left:16, top:16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Color(0xff242424),
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Admin", style: GoogleFonts.sarpanch(color: Colors.green, fontSize: 24, fontWeight: FontWeight.w300),),
                  ),
                ),
                ListTile(
                  title: Text('Account', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Device', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Security', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                Container(
                  padding: EdgeInsets.only(left:16, top:16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Color(0xff242424),
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("General", style: GoogleFonts.sarpanch(color: Colors.green, fontSize: 24, fontWeight: FontWeight.w300),),
                  ),
                ),
                ListTile(
                  title: Text('Notifications', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Display & Sound', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Data Usage', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('About', style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                SwitchListTile(
                    title: Text("Is this the real life? Is this just fantasy? ", style: TextStyle(fontSize: 18,color: Colors.white)),
                    value: realLife,
                    onChanged: (bool value) {
                      setState(() {
                        realLife = value;
                      });
                    },
                  secondary: const Icon(Icons.change_history, color: Colors.white,),
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.green,
                ),
                Padding(
                  padding: EdgeInsets.only(top:30),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.green)
                    ),
                    child: Text(
                      'Logout',
                        style: GoogleFonts.bungeeHairline(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
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
