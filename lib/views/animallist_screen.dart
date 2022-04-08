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
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  final TextEditingController searchController = new TextEditingController();
  TextEditingController collectionNameField = new TextEditingController();
  bool showForm = false;

  sortOption _selection = sortOption.alpha;

  List _allResults = [];
  List _resultsList = [];

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      onSearchChanged();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(() {
      onSearchChanged();
    });
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  onSearchChanged() {
    searchResultsList();
    print(searchController.text);
  }

  searchResultsList() {
    var showResults = [];

    if (searchController.text != "") {
      for (var animalSnapshot in _allResults) {
        var commonName =
            Animal.fromSnapshot(animalSnapshot).commonName.toLowerCase();
        if (commonName.contains(searchController.text.toLowerCase())) {
          showResults.add(animalSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff), body: _buildViewSmall(context));
  }

  Widget _buildViewSmall(BuildContext context) {
    if (!isSearching) {
      searchController.text = "";
    }

    return Column(children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !isSearching
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 40,
                        ),
                      )
                    : SizedBox(),
                Flexible(
                  child: !isSearching
                      ? Text(
                          "Project Sanctuary",
                          style: GoogleFonts.bungeeHairline(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )
                      : TextField(
                          controller: searchController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              hintText: "Search Sanctuary",
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    color: Colors.black,
                    icon:
                        !isSearching ? Icon(Icons.search) : Icon(Icons.cancel),
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
            SizedBox(
              height: 16,
            ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Now Showing: ",
                                style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: PopupMenuButton<sortOption>(
                      icon: Icon(
                        Icons.sort,
                        color: Colors.black,
                        size: 34,
                      ),
                      onSelected: (sortOption result) {
                        setState(() {
                          _selection = result;
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<sortOption>>[
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
                    ))
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

  Widget _buildViewLarge(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Text(
              "TEST",
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
          ],
        ));
  }

  Widget _buildCollection(BuildContext context, Animal animal) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('collectionNames').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          //print(snapshots.item1.data.);
          return _buildCollectionList(context, snapshot.data.docs, animal);
        }
      },
    );
  }

  Widget _buildCollectionList(
      BuildContext context, List<DocumentSnapshot> snapshot, Animal animal) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        ...snapshot
            .map((data) => _buildCollectionListItem(context, data, animal))
            .toList()
      ],
    );
  }

  Widget _buildCollectionListItem(
      BuildContext context, DocumentSnapshot data, Animal animal) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    final collection = Collection.fromSnapshot(data);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            width: 130,
            height: 130,
            child: InkWell(
              onTap: () {
                saveToExistingCollection(animal, collection.name, data);
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white54, width: 0.35),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Color(0xff2c2c2c),
                        child: Image.network(collection.imgURL,
                            fit: BoxFit.fitHeight)),
                  ),

                  /// Part of code to make animals save-able to multiple collections
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Checkbox(
                  //       checkColor: Colors.white,
                  //       fillColor: MaterialStateProperty.resolveWith(getColor),
                  //       value: isChecked,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           isChecked = value;
                  //         });
                  //       },
                  //     ),
                  //     Text(
                  //       collection.name,
                  //       overflow: TextOverflow.ellipsis,
                  //     )
                  //   ],
                  // ),
                  Text(
                    collection.name,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveToNewCollection(
      Animal animal, CollectionReference faves, DocumentSnapshot data) async {
    var stringVal;
    List collectionNameList = [];
    // colName.add(collectionNameField.text);
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("collectionNames").get();
    snapshot.docs.forEach((document) async {
      if (document.exists) {
        //print('Documents exist');

        Map<String, dynamic> val = document.data();
        // print("The value is " + document.get("name"));

        collectionNameList.add(document.get("name"));

        var tempVal =
            val.values.toString().replaceAll(new RegExp(r'[^\w\s]+'), '');

        //await Firestore.instance.collection("favourites").document().collection(playlistName.text);
      } else {
        print("Document doesn't exist");
      }
    });

    Map<String, dynamic> animalData = animal.toJson();
    if (collectionNameList.contains(collectionNameField.text.toLowerCase())) {
      print("Collection already exists");
      return;
    } else {
      await FirebaseFirestore.instance
          .collection("collections")
          .doc("collectionLists")
          .collection(collectionNameField.text)
          .doc(data.id)
          .set(animalData);
      await FirebaseFirestore.instance
          .collection("collectionNames")
          .doc()
          .set({"name": collectionNameField.text, "imgURL": "animal.imgUrl"});
      await FirebaseFirestore.instance
          .collection('animals')
          .doc(data.id)
          .update({'collection': collectionNameField.text});
    }
  }

  void saveToExistingCollection(
      Animal animal, String collectionName, DocumentSnapshot data) async {
    var stringVal;
    List colName = [];
    colName.add(collectionName);
    Map<String, dynamic> animalData = animal.toJson();

    await FirebaseFirestore.instance
        .collection("collections")
        .doc("collectionLists")
        .collection(collectionName)
        .doc(data.id)
        .set(animalData);

    await FirebaseFirestore.instance
        .collection("animals")
        .doc(data.id)
        .update({'collection': collectionName});
  }

  Widget _buildBody(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
      streams: Tuple2(
        ((_selection == sortOption.alpha)
            ? FirebaseFirestore.instance
                .collection('animals')
                .orderBy('commonName', descending: false)
                .snapshots()
            : (_selection == sortOption.reverseAlpha)
                ? FirebaseFirestore.instance
                    .collection('animals')
                    .orderBy('commonName', descending: true)
                    .snapshots()
                : (_selection == sortOption.recentlyAdded)
                    ? FirebaseFirestore.instance
                        .collection('animals')
                        .orderBy('dateAdded', descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('animals')
                        .orderBy('commonName', descending: false)
                        .snapshots()),
        FirebaseFirestore.instance.collection('collectionNames').snapshots(),
      ),
      builder: (context, snapshots) {
        if (!snapshots.item1.hasData) {
          // If animal list is empty we show a loading spinner
          return CircularProgressIndicator();
        } else {
          _allResults = snapshots.item1.data.docs;
          return (_width > 600)
              ? _buildGridList(
                  context, snapshots.item1.data.docs, snapshots.item2.data.docs)
              : _buildList(context, snapshots.item1.data.docs,
                  snapshots.item2.data.docs);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      List<DocumentSnapshot> faves) {
    return isSearching
        ? ListView.builder(
            itemCount: _resultsList.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildListItem(context, _resultsList[index], faves),
          )
        : ListView(
            children: [
              ...snapshot
                  .map((data) => _buildListItem(context, data, faves))
                  .toList()
            ],
          );
  }

  Widget _buildGridList(BuildContext context, List<DocumentSnapshot> snapshot,
      List<DocumentSnapshot> faves) {
    return GridView.count(
        //itemExtent: 5,
        //padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        crossAxisCount: 2,
        children: snapshot
            .map((data) => _buildListItem(context, data, faves))
            .toList());
  }

  void addToFaves(
      Animal animal, CollectionReference faves, DocumentSnapshot data) {
    Map<String, dynamic> animalData = animal.toJson();
    faves.doc(data.id).set(animalData);
  }

  void removeFromFaves(
      Animal animal, CollectionReference faves, DocumentSnapshot data) async {
    await faves.doc(data.id).delete();
    await FirebaseFirestore.instance
        .collection("animals")
        .doc(data.id)
        .update({"collection": FieldValue.delete()});

    print('Removed from faves ' + data.id);
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data,
      List<DocumentSnapshot> faves) {
    final animal = Animal.fromSnapshot(data);

    bool isInFaves = false;
    bool faveIcon = false;
    var collectionNameRef;
    Animal faveList;

    //This works, but we'll look for a more efficient way to do it later
    // if (animal.collections != null) {
    //   faveIcon = true;
    // }

    if (animal.collection != null) {
      isInFaves = true;
    }

    for (var data in faves) {
      Map<String, dynamic> val = data.data();
      collectionNameRef =
          val.values.toString().replaceAll(new RegExp(r'[^\w\s]+'), '');
    }

    CollectionReference favorite =
        FirebaseFirestore.instance.collection('collectionNames');
    CollectionReference fave = FirebaseFirestore.instance
        .collection('collections')
        .doc("collectionLists")
        .collection("collectionPath");

    // if (animal.isActive) { activeAlien = animal.species.toString(); }
    // if (animal.environment == "space") { shadowColor = Colors.white; }
    // else if (animal.environment == "land") { shadowColor = Colors.brown; }
    // else if (animal.environment == "ice") { shadowColor = Colors.blueAccent; }
    // else if (animal.environment == "water") { shadowColor = Colors.blue; }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
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
                            )),
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
                          animal.imgURLS.first,
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
                          Text(
                            animal.scientificName,
                            style: GoogleFonts.sarpanch(
                                color: Colors.orange,
                                fontSize: 28,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "Common Name: " + animal.commonName,
                            style: GoogleFonts.lato(
                                color: Colors.white54, fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16),
                                child: IconButton(
                                  icon: isInFaves
                                      ? Icon(CupertinoIcons.bookmark_fill)
                                      : Icon(CupertinoIcons.bookmark),
                                  color: Colors.white,
                                  iconSize: 32,
                                  onPressed: () async {
                                    // _showMyDialog(animal, favorite, data);
                                    if (isInFaves) {
                                      removeFromFaves(animal, favorite, data);
                                      setState(() {
                                        isInFaves = false;
                                      });
                                    } else {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setNewState) {
                                              return Container(
                                                // width: double.maxFinite,
                                                height: 350,
                                                child: ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                            child: Text(
                                                              "Collections",
                                                              style: TextStyle(
                                                                  fontSize: 22),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: showForm
                                                                ? Form(
                                                                    key:
                                                                        formKey,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          collectionNameField,
                                                                      validator:
                                                                          (value) {
                                                                        return value.isNotEmpty
                                                                            ? null
                                                                            : "Invalid Field";
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                              hintText: "Collection Name"),
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: !showForm
                                                                      ? Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              28,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              28,
                                                                        ),
                                                                  onPressed:
                                                                      () {
                                                                    setNewState(
                                                                        () {
                                                                      showForm =
                                                                          !showForm;
                                                                    });
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                    height: 150,
                                                                    child: _buildCollection(
                                                                        context,
                                                                        animal)),
                                                              ],
                                                            ),
                                                          ),
                                                          showForm
                                                              ? TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  child: Text(
                                                                      "Save"),
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        "save button clicked");
                                                                    saveToNewCollection(
                                                                        animal,
                                                                        favorite,
                                                                        data);
                                                                  },
                                                                )
                                                              : SizedBox()
                                                        ],
                                                      ),
                                                    ]),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                    // Faves FINALLY freaking works
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
