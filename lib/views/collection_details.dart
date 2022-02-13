import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/models/animal-model.dart';
import 'package:sanctuary/models/collection_model.dart';
import 'package:sanctuary/views/animal_details.dart';

// TODO: Add other sort options
enum sortOption { alpha, reverseAlpha, recentlyAdded }
bool isSearching = false;
Color shadowColor;
String activeAlien = "";

class CollectionDetails extends StatelessWidget {

  final Collection collection;
  CollectionDetails({this.collection});

  final TextEditingController searchController = new TextEditingController();

  sortOption _selection = sortOption.alpha;

  List _allResults = [];


  /*
  @override
  void initState()
  {
    super.initState();
    searchController.addListener(() {onSearchChanged();});
  }

   */

  /*
  @override
  void dispose()
  {
    searchController.removeListener(() {onSearchChanged();});
    searchController.dispose();
    super.dispose();
  }

   */

  onSearchChanged()
  {
    print(searchController.text);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: Color(0xfff5f5f5),
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
                    !isSearching ? Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: ()
                        {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.black, size: 32,),

                      ),
                    ) : SizedBox(),
                    Flexible(
                      child: !isSearching ? Text("collections", style: GoogleFonts.bungeeHairline(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),) :
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
                          /*
                          setState(() {
                            isSearching = !isSearching;
                          });
                          */
                        },),
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
                          onSelected: (sortOption result) { /*setState(() { _selection = result; });*/ },
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
    return StreamBuilder<QuerySnapshot>(
      stream:
        ((_selection == sortOption.alpha) ? FirebaseFirestore.instance.collection('favourites').doc("playlists").collection(collection.name).orderBy('class', descending: false).snapshots()
            : (_selection == sortOption.reverseAlpha)? FirebaseFirestore.instance.collection('favourites').doc("playlists").collection(collection.name).orderBy('order', descending: true).snapshots()
            :(_selection == sortOption.recentlyAdded)? FirebaseFirestore.instance.collection('favourites').doc("playlists").collection(collection.name).orderBy('dateAdded', descending: true).snapshots():FirebaseFirestore.instance.collection('aliens').orderBy('species', descending: false).snapshots()),

      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.hasData) {
          return CircularProgressIndicator();
        }
        else {
          //print(snapshots.item1.data.);

          return (_width > 600)? _buildGridList(context, snapshot.data.docs, snapshot.data.docs) : _buildList(context, snapshot.data.docs, snapshot.data.docs);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, List<DocumentSnapshot> faves) {
    //print(snapshot.length);

    return ListView(

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
    Map<String, dynamic> alienData = animal.toJson();
    faves.doc(data.id).set(alienData);
  }

  void removeFromFaves(Animal animal, CollectionReference faves, DocumentSnapshot data)
  {
    faves.doc(data.id).delete();
  }



  Widget _buildListItem(BuildContext context, DocumentSnapshot data, List<DocumentSnapshot> faves) {
    final animal = Animal.fromSnapshot(data);
    bool isInFaves = false;
    bool faveIcon = false;


    Animal faveList;
    //This works, but we'll look for a more efficient way to do it later

    for (var data in faves)
    {
      Map<String, dynamic> values = data.data();
      //print(values);
      //return alienVal;
    }
    // for (var data in faves)
    // {
    //   var dataRes = Alien.fromSnapshot(data);
    //   faveList = dataRes;
    //
    //   if (alien.codename == dataRes.codename)
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


    CollectionReference favorite = FirebaseFirestore.instance.collection('favourites');

  /*  if (animal.isActive) { activeAlien = animal.species.toString(); }

    if (alien.environment == "space") { shadowColor = Colors.white; }
    else if (alien.environment == "land") { shadowColor = Colors.brown; }
    else if (alien.environment == "ice") { shadowColor = Colors.blueAccent; }
    else if (alien.environment == "water") { shadowColor = Colors.blue; }*/


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
                          Text(animal.order, style: GoogleFonts.sarpanch(color: Colors.green, fontSize: 18, fontWeight: FontWeight.w300),),
                          Text("Common Name: \n" + animal.commonName, style: GoogleFonts.lato(color: Colors.white54,fontSize: 16),),
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
                              //

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:2.0),
                                child: IconButton(
                                  //icon: Icon(CupertinoIcons.bookmark),
                                  //icon: isFavourited(data.documentID).then((value) {return Icon(CupertinoIcons.book);}) != null ? returnFilledIcon(context) : returnOutlinedIcon(context),
                                  icon: faveIcon? Icon(CupertinoIcons.bookmark_fill) : Icon(CupertinoIcons.bookmark),
                                  color: Colors.white,
                                  iconSize: 18,

                                  onPressed: () async {
                                    /*
                                    setState(() {
                                      faveIcon = !faveIcon;
                                    });

                                     */



                                    // Faves FINALLY freaking works
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
                              //     child: alien.isActive ? Icon(Icons.circle, color: Colors.green, size: 12) : null,
                              //   ),
                              // )
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
                            builder: (context) => AnimalDetails(
                              animal: animal,
                            )
                        ),
                      );
                    },
                    child: Image.network(
                      animal.imgUrl,
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

