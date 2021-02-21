import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omnitrix_database_flutter/models/models.dart';
import 'package:omnitrix_database_flutter/services/auth.dart';
import 'package:omnitrix_database_flutter/views/alien_details.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';


String activeAlien = "";

Color shadowColor;

enum sortOption { alpha, reverseAlpha, recentlyAdded }

@JsonSerializable()
/// NOTE: When we begin to integrate animal data from A-Z animals, due to
/// copyright issues, the app CANNOT be monetized
class AlienListScreen extends StatefulWidget {
  @override
  _AlienListScreenState createState() => _AlienListScreenState();
}

class _AlienListScreenState extends State<AlienListScreen> {

  final AuthService _auth = AuthService();
  sortOption _selection = sortOption.alpha;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 15,
                      child: Container(
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
                    ),
                    Flexible(
                      flex: 2,
                        child: PopupMenuButton<sortOption>(
                                icon: Icon(Icons.sort,color: Colors.white,),
                                onSelected: (sortOption result) { setState(() { _selection = result; }); },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<sortOption>>[
                                  const PopupMenuItem<sortOption>(
                                    value: sortOption.alpha,
                                    child: Text('A-Z'),
                                  ),
                                  const PopupMenuItem<sortOption>(
                                    value: sortOption.reverseAlpha,
                                    child: Text('Z-A'),
                                  ),
                                  const PopupMenuItem<sortOption>(
                                    value: sortOption.recentlyAdded,
                                    child: Text('Recently Added'),
                                  ),
                                ],
                              )
                            )
                  ],
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
    return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
      streams:Tuple2(/// TODO : REVIEW HOW DATE IS SORTED
        ((_selection == sortOption.alpha) ? Firestore.instance.collection('aliens').orderBy('species', descending: false).snapshots()
              : (_selection == sortOption.reverseAlpha)? Firestore.instance.collection('aliens').orderBy('species', descending: true).snapshots()
                :(_selection == sortOption.recentlyAdded)? Firestore.instance.collection('aliens').orderBy('dateAdded', descending: false).snapshots():null),
                  Firestore.instance.collection('favourites').snapshots(),
      ),
      builder: (context, snapshots) {
        if (!snapshots.item1.hasData) {
            return CircularProgressIndicator();
          }
        else {
          return (_width > 600)? _buildGridList(context, snapshots.item1.data.documents, snapshots.item2.data.documents) : _buildList(context, snapshots.item1.data.documents, snapshots.item2.data.documents);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, List<DocumentSnapshot> faves) {
    return ListView(
      children:snapshot.map((data) => _buildListItem(context, data, faves)).toList(),
    );
  }

  Widget _buildGridList(BuildContext context, List<DocumentSnapshot> snapshot, List<DocumentSnapshot> faves) {
    return GridView.count(
      //itemExtent: 5,
      //padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        crossAxisCount: 2,
        children:snapshot.map((data) => _buildListItem(context, data, faves)).toList()
    );
  }

  void addToFaves(Alien alien, CollectionReference faves, DocumentSnapshot data)
  {
    Map<String, dynamic> alienData = alien.toJson();
    faves.document(data.documentID).setData(alienData);
  }

  void removeFromFaves(Alien alien, CollectionReference faves, DocumentSnapshot data)
  {
    faves.document(data.documentID).delete();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data, List<DocumentSnapshot> faves) {
    final alien = Alien.fromSnapshot(data);
    bool isInFaves = false;
    bool faveIcon = false;

    Alien faveList;
    //This works, but we'll look for a more efficient way to do it later
    for (var data in faves)
    {
      var dataRes = Alien.fromSnapshot(data);
      faveList = dataRes;

      if (alien.codename == dataRes.codename)
        {
          isInFaves = true;
          faveIcon = true;
        }
      else
      {
        isInFaves = false;
      }
      //return alienVal;
    }


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
                                  //icon: Icon(CupertinoIcons.bookmark),
                                  //icon: isFavourited(data.documentID).then((value) {return Icon(CupertinoIcons.book);}) != null ? returnFilledIcon(context) : returnOutlinedIcon(context),
                                  icon: faveIcon? Icon(CupertinoIcons.bookmark_fill) : Icon(CupertinoIcons.bookmark),
                                  color: Colors.white,
                                  iconSize: 18,
                                onPressed: () async {
                                  setState(() {
                                    faveIcon = !faveIcon;
                                  });
                                  // Faves FINALLY freaking work

                                  if (isInFaves)
                                    {
                                      removeFromFaves(alien, favorite, data);
                                    }
                                  else
                                    {
                                      addToFaves(alien, favorite, data);
                                    }
                                  /*
                                  if (await isFavourited(data.documentID) == null)
                                  {
                                    Map<String, dynamic> alienData = alien.toJson();
                                    await favorite.document(data.documentID).setData(alienData);
                                  }

                                  else{
                                    //remove
                                    //print(data.documentID);
                                    favorite.document(data.documentID).delete();
                                  }
                                  */
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
