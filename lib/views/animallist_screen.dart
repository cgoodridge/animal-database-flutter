import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/models/collection_model.dart';
import 'package:sanctuary/models/models.dart';
import 'package:sanctuary/services/auth.dart';
import 'package:sanctuary/views/animal_details.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';



String activeAlien = "";
Color shadowColor;

// TODO: Add other sort options
// TODO: Replace list views with listview.builder
enum sortOption { alpha, reverseAlpha, recentlyAdded }

@JsonSerializable()
/// NOTE: When we begin to integrate animal data from A-Z animals, due to
/// copyright issues, the app CANNOT be monetized
class AnimalListScreen extends StatefulWidget {
  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {

  final TextEditingController searchController = new TextEditingController();

  sortOption _selection = sortOption.alpha;

  List _allResults = [];
  List _resultsList = [];

  bool isSearching = false;

  @override
  void initState()
  {
    super.initState();
    searchController.addListener(() {onSearchChanged();});
  }

  @override
  void dispose()
  {
    searchController.removeListener(() {onSearchChanged();});
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  onSearchChanged()
  {
    searchResultsList();
    print(searchController.text);
  }

  searchResultsList()
  {
    var showResults = [];

    if (searchController.text != "")
      {
        for (var animalSnapshot in _allResults)
          {
            var commonName = Animal.fromSnapshot(animalSnapshot).commonName.toLowerCase();
            if (commonName.contains(searchController.text.toLowerCase()))
              {
                showResults.add(animalSnapshot);
              }
          }
      }
    else
      {
        showResults = List.from(_allResults);
      }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body:_buildViewSmall(context)
    );
  }

  Widget _buildViewSmall(BuildContext context)
  {

    if(!isSearching) {
      searchController.text = "";
    }

    return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !isSearching ? Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset('assets/images/logo.png', width: 40,),
                    ) : SizedBox(),
                    Flexible(
                        child: !isSearching ? Text("Project Sanctuary", style: GoogleFonts.bungeeHairline(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),) :
                        TextField(
                          controller: searchController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Colors.black,),
                              hintText: "Search Sanctuary",
                              hintStyle: TextStyle(color: Colors.black)
                          ),
                        ),
                    ),

                    Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          color: Colors.black,
                          icon: !isSearching ? Icon(Icons.search) : Icon(Icons.cancel),
                          onPressed: () {
                            // Expand search Field
                            setState(() {
                              isSearching = !isSearching;
                            });
                          },
                        ),
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
                          color: Colors.black12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Now Showing: " , style: GoogleFonts.lato(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                        child: PopupMenuButton<sortOption>(
                                icon: Icon(Icons.sort,color: Colors.black, size: 34,),
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
            child: _buildBody(context),
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
      streams:Tuple2(
        ((_selection == sortOption.alpha) ? FirebaseFirestore.instance.collection('animals').orderBy('common-name', descending: false).snapshots()
              : (_selection == sortOption.reverseAlpha)? FirebaseFirestore.instance.collection('animals').orderBy('common-name', descending: true).snapshots()
                :(_selection == sortOption.recentlyAdded)? FirebaseFirestore.instance.collection('animals').orderBy('dateAdded', descending: true).snapshots():FirebaseFirestore.instance.collection('animals').orderBy('common-name', descending: false).snapshots()),

        FirebaseFirestore.instance.collection('playlistNames').snapshots(),
      ),

      builder: (context, snapshots) {
        if (!snapshots.item1.hasData || !snapshots.item2.hasData) {
          return CircularProgressIndicator();
        } else {
          _allResults = snapshots.item1.data.docs;
          return (_width > 600)? _buildGridList(context, snapshots.item1.data.docs, snapshots.item2.data.docs) : _buildList(context, snapshots.item1.data.docs, snapshots.item2.data.docs);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, List<DocumentSnapshot> faves) {

    return isSearching ? ListView.builder(
      itemCount: _resultsList.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildListItem(context, _resultsList[index], faves),
    ) : ListView(
      children:[
        ...snapshot.map((data) => _buildListItem(context, data, faves)).toList()
      ],
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

  void addToFaves(Animal animal, CollectionReference faves, DocumentSnapshot data)
  {
    Map<String, dynamic> animalData = animal.toJson();
    faves.doc(data.id).set(animalData);
  }

  void removeFromFaves(Animal animal, CollectionReference faves, DocumentSnapshot data) async {
    await faves.doc(data.id).delete();
    print('Remove from faves ' + data.id);
  }

  Future<void> _showMyDialog(Animal animal, CollectionReference faves, DocumentSnapshot data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) {
        return PlaylistForm(animal: animal, favorite: faves, data: data);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data, List<DocumentSnapshot> faves) {
    final animal = Animal.fromSnapshot(data);
    bool isInFaves = false;
    bool faveIcon = false;
    var playlistName;
    Animal faveList;
    //This works, but we'll look for a more efficient way to do it later
    print(animal);
    if (animal.collections != null)
    {
        faveIcon = true;
    }

    for (var data in faves)
    {
      Map<String, dynamic> val = data.data();
      playlistName =  val.values.toString().replaceAll(new RegExp(r'[^\w\s]+'),'');
      //print(playlistName);

      //return alienVal;
    }

    CollectionReference favorite = FirebaseFirestore.instance.collection('playlistNames').doc("playlists").collection("collectionPath");
    CollectionReference fave = FirebaseFirestore.instance.collection('favourites').doc("playlists").collection("collectionPath");

    // for (var data in faves)
    // {
    //   var dataRes = Alien.fromSnapshot(data);
    //   faveList = dataRes;
    //
    //   if (animal.codename == dataRes.codename)
    //     {
    //       isInFaves = true;
    //       faveIcon = true;
    //     }
    //   else
    //   {
    //     isInFaves = false;
    //   }
    //   //return alienVal;
    // }

    // if (animal.isActive) { activeAlien = animal.species.toString(); }
    //
    // if (animal.environment == "space") { shadowColor = Colors.white; }
    // else if (animal.environment == "land") { shadowColor = Colors.brown; }
    // else if (animal.environment == "ice") { shadowColor = Colors.blueAccent; }
    // else if (animal.environment == "water") { shadowColor = Colors.blue; }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 500,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white54, width: 0.35),
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          elevation: 5,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnimalDetails(
                      animal: animal,
                    )
                ),
              );
            },
            child: Stack(
              children: [
              Container(
                    height: 500,
                    width: double.infinity,
                    child: Hero(
                      tag: animal.commonName,
                      child: Image.network(
                        animal.imgUrl,
                        fit: BoxFit.fitHeight,
                        // height: 200,
                      ),
                    ),
                  ),
              Container(
                      // constraints: BoxConstraints.expand(),
                      height: 500,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.transparent])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(animal.scientificName, style: GoogleFonts.sarpanch(color: Colors.orange, fontSize: 28, fontWeight: FontWeight.w300),),
                          Text("Common Name: " + animal.commonName, style: GoogleFonts.lato(color: Colors.white54,fontSize: 20),),
                          SizedBox(height:16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical:16),
                                child: IconButton(
                                  icon: faveIcon? Icon(CupertinoIcons.bookmark_fill) : Icon(CupertinoIcons.bookmark),
                                  color: Colors.white,
                                  iconSize: 32,
                                  onPressed: () async {
                                    if (faveIcon) {
                                      removeFromFaves(animal, favorite, data);
                                    } else {
                                      print('Add to faves');
                                      _showMyDialog(animal, favorite, data);
                                    }
                                    // Faves FINALLY freaking work
                                    /*
                                            if (isInFaves)
                                              {
                                                removeFromFaves(alien, favorite, data);
                                              }
                                            else
                                              {
                                                addToFaves(alien, favorite, data);
                                              }
                                            */
                                  },
                                ),
                              ),
                              // Flexible(
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(horizontal:6.0),
                              //     child: animal.isActive ? Icon(Icons.circle, color: Colors.green, size: 12) : null,
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          )
        ),
      )
    );
  }
}

class PlaylistForm extends StatefulWidget {
  final Animal animal;
  final CollectionReference favorite;
  final DocumentSnapshot data;

  PlaylistForm({ Key key, this.animal, this.favorite, this.data}): super(key: key);

  @override
  _PlaylistFormState createState() => _PlaylistFormState();
}

class _PlaylistFormState extends State<PlaylistForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController playlistName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Save to Playlist'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                controller: playlistName,
                validator: (value){
                  return value.isNotEmpty? null : "Invalid Field";
                },
                decoration: InputDecoration(
                    hintText: "Playlist Name"
                ),
              ),
            ),
            SizedBox(
                height: 140,
                child: _buildCollection(context)
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Submit'),
          onPressed: () {
            saveToNewCollection(widget.animal, widget.favorite, widget.data);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildCollection(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('playlistNames').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.hasData) {
          return CircularProgressIndicator();
        }
        else {
          //print(snapshots.item1.data.);
          return _buildCollectionList(context, snapshot.data.docs);
        }
      },
    );
  }

  Widget _buildCollectionList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children:[
        ...snapshot.map((data) => _buildCollectionListItem(context, data)).toList()
      ],
    );
  }

  Widget _buildCollectionListItem(BuildContext context, DocumentSnapshot data){
    final collection = Collection.fromSnapshot(data);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Text(collection.name),
          Container(
            width: 100,
            height: 100,
            child: InkWell(
              onTap: (){
                saveToExistingCollection(widget.animal, collection.name, widget.data);
                Navigator.of(context).pop();
              },
              child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white54, width: 0.35),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                color: Color(0xff2c2c2c),
                child: Text("Text", style: TextStyle(color: Colors.white),)
              ),
            ),
          )
        ],
      ),
    );
  }

  void saveToNewCollection(Animal animal, CollectionReference faves, DocumentSnapshot data) async
  {
    var stringVal;
    List colName = [];
    colName.add(playlistName.text);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("playlistNames").get();
    snapshot.docs.forEach((document) {
      if (document.exists) {
        //print('Documents exist');
        Map<String, dynamic> val = document.data();
        var tempVal =  val.values.toString().replaceAll(new RegExp(r'[^\w\s]+'),'');
        print(tempVal);
        setState(() {
          stringVal = tempVal;
        });
      }
      else {
        print('document does not exist');
      }
    });

    //print(stringVal.toString());

    if (formKey.currentState.validate())
    {
      Map<String, dynamic> animalData = animal.toJson();
      if (stringVal.toString() == playlistName.text)
        {
          print(true);
        } else {

        //await Firestore.instance.collection("favourites").document().collection(playlistName.text);
        await FirebaseFirestore.instance.collection("favourites").doc("playlists").collection(playlistName.text).doc(data.id).set(animalData);
        await FirebaseFirestore.instance.collection("playlistNames").doc().set({"name": playlistName.text, "imgURL": animal.imgUrl});
        await FirebaseFirestore.instance.collection('animals').doc(data.id).update({'collections': FieldValue.arrayUnion(colName)});
      }
    }
  }

  void saveToExistingCollection(Animal animal, String collectionName, DocumentSnapshot data) async
  {
    var stringVal;
    List colName = [];
    colName.add(collectionName);
    Map<String, dynamic> animalData = animal.toJson();
    await FirebaseFirestore.instance.collection("favourites").doc("playlists").collection(collectionName).doc(data.id).set(animalData);
    await FirebaseFirestore.instance.collection("animals").doc(data.id).update({'collections': FieldValue.arrayUnion(colName)});

    print("Animal added to " + collectionName);
  }
}