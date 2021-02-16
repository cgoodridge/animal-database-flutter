import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsScreen extends StatefulWidget {
  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2C2C2C),
      body: Container(
        child: ListView(
           children: [
             Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   child: Text("Location", style: GoogleFonts.bungeeHairline(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),),
                 ),
               ],
             ),
           ],
        ),
      ),
    );
  }
}
