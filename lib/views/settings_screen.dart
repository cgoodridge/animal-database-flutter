import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/services/auth.dart';
import 'package:sanctuary/utils/dart_theme_provider.dart';
import 'package:provider/provider.dart';

/// TODO: Add confirmation dialog for logout button
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _auth = AuthService();
  bool themeVal = false;
  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      // backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        iconTheme: IconThemeData(
            size: 32),
        // backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "settings",
          style: GoogleFonts.bungeeHairline(
              fontSize: 34, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  decoration: BoxDecoration(
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Admin",
                      style: GoogleFonts.sarpanch(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Device',
                      style: TextStyle(fontSize: 18)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Security',
                      style: TextStyle(fontSize: 18)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "General",
                      style: GoogleFonts.sarpanch(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Notifications',
                      style: TextStyle(fontSize: 18)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Display & Sound',
                      style: TextStyle(fontSize: 18)),
                ),
                Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('Data Usage',
                      style: TextStyle(fontSize: 18)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                SwitchListTile(
                  value: themeChange.darkTheme,
                  onChanged: (bool val) {
                    setState(() {
                      themeChange.darkTheme = val;
                    });
                  },
                  title: Text('Theme',
                      style: TextStyle(fontSize: 18)),
                  subtitle: Text(!themeVal ? 'Light': 'Dark'),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
                ListTile(
                  title: Text('About',
                      style: TextStyle(fontSize: 18)),
                ),
                Divider(
                  height: 1,
                  color: Colors.black54,
                  thickness: 0.1,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
