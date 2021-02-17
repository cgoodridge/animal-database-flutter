import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omnitrix_database_flutter/models/models.dart';
import 'package:omnitrix_database_flutter/services/auth.dart';
import 'package:omnitrix_database_flutter/views/alien_details.dart';


String activeAlien = "";
bool favouriteIcon = false;
Color shadowColor;

@JsonSerializable()
/// NOTE: When we begin to integrate animal data from A-Z animals, due to
/// copyright issues, the app CANNOT be monetized
class AlienListScreen extends StatefulWidget {
  @override
  _AlienListScreenState createState() => _AlienListScreenState();
}

class _AlienListScreenState extends State<AlienListScreen> {

  final AuthService _auth = AuthService();
  final Set<Alien> _saved = new Set<Alien>();



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xff2C2C2C),
      //body:(_width > 500)? _buildViewLarge(context) : _buildViewSmall(context)
      body:_buildViewSmall(context)

    );
  }

  Widget _buildViewSmall(BuildContext context)
  {
    return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset('assets/images/omnitrix.png', width: 40,),
                    ),
                    Text("codon stream", style: GoogleFonts.bungeeHairline(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.search, color: Colors.white),
                        /*
                        child: FlatButton.icon(
                          icon: Icon(Icons.search, color: Colors.white,),
                          label: Text(""),
                          onPressed: () async {
                            //await _auth.signOut();
                          },
                        )
                        */
                    )
                  ],
                ),
                SizedBox(height: 16,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff242424),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(

                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.circle, color: Colors.green, size: 12,),
                        ),
                        Text("Active Sample: " + activeAlien, style: GoogleFonts.lato(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(height: 200.0, child: _buildBody(context)),
          ),
        ]);
  }

  Widget _buildViewLarge(BuildContext context)
  {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Text("TEST", style: TextStyle(color: Colors.white, fontSize: 26),),
          ],
        )
      );
  }

  Widget _buildBody(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('aliens')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return (_width > 600)? _buildGridList(context, snapshot.data.documents) : _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children:snapshot.map((data) => _buildListItem(context, data)).toList()
    );
  }

  Widget _buildGridList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      //itemExtent: 5,
      //padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        crossAxisCount: 2,
        children:snapshot.map((data) => _buildListItem(context, data)).toList()

    );
  }

  Future<DocumentSnapshot> isFavourited(String docId) async
  {
    final snapshot = await Firestore.instance.collection('favourites').document(docId).get();

    if (snapshot.exists)
    {
      return snapshot;
    }
    else{
      return null;
    }

  }

  Widget returnFilledIcon(BuildContext context)
  {
    return Icon(CupertinoIcons.bookmark_fill);
  }
  Widget returnOutlinedIcon(BuildContext context)
  {
    return Icon(CupertinoIcons.bookmark);
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final alien = Alien.fromSnapshot(data);
    final alienSaved = _saved.contains(alien);

    //print(_saved.first);
    CollectionReference favorite = Firestore.instance.collection('favourites');

    if (alien.isActive) { activeAlien = alien.species.toString(); }

    if (alien.environment == "space") { shadowColor = Colors.white; }
    else if (alien.environment == "land") { shadowColor = Colors.brown; }
    else if (alien.environment == "ice") { shadowColor = Colors.blueAccent; }
    else if (alien.environment == "water") { shadowColor = Colors.blue; }


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Container(
        height: 220,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white54, width: 0.35),
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: Color(0xff363636),
          elevation: 5,
          child: Row(
            children: [
              Container(
                height: 220,
                width: 180,
                child: Card(
                  //shadowColor: Colors.green,
                  shadowColor: shadowColor,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.zero,
                  elevation: 20,
                  color: Color(0xff242424),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(alien.species, style: GoogleFonts.sarpanch(color: Colors.green, fontSize: 18, fontWeight: FontWeight.w300),),
                        Text("Codename: \n" + alien.codename, style: GoogleFonts.lato(color: Colors.white54,fontSize: 16),),
                        /*
                        Text("Description: " + alien.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: GoogleFonts.lato(color: Colors.white54),
                        ),
                        */
                        SizedBox(height:16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:2.0),
                              child: IconButton(
                                  //icon: isFavourited(data.documentID).then((value) {return Icon(CupertinoIcons.book);}) != null ? returnFilledIcon(context) : returnOutlinedIcon(context),
                                  icon: alienSaved? Icon(CupertinoIcons.bookmark_fill) : Icon(CupertinoIcons.bookmark),
                                  color: Colors.white,
                                  iconSize: 18,
                                onPressed: () async {
                                  ///TODO: Add check to see if alien is already favourited

                                  print(alienSaved);

                                  if (await isFavourited(data.documentID) == null)
                                  {
                                    Map<String, dynamic> alienData = alien.toJson();
                                    //print(alienData);
                                    await favorite.document(data.documentID).setData(alienData);
                                    if (alienSaved) {
                                      _saved.remove(alien);
                                    } else {
                                      _saved.add(alien);
                                    }
                                  }

                                  else{
                                    //remove
                                    //print(data.documentID);
                                    favorite.document(data.documentID).delete();
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: alien.isActive ? Icon(Icons.circle, color: Colors.green, size: 12) : null,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 200,
                width: 175,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlienDetails(
                            alien: alien,
                          )
                      ),
                    );
                  },
                  child: Image.network(
                    alien.imgUrl,
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
