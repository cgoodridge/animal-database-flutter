import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sanctuary/models/collection_model.dart';
import 'animal_details.dart';
import 'collection_details.dart';

String activeAlien = "";
Color shadowColor;
class CollectionsScreen extends StatefulWidget {
  @override
  _CollectionsScreenState createState() => _CollectionsScreenState();

}

class _CollectionsScreenState extends State<CollectionsScreen> {

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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset('assets/images/logo.png', width: 40,),
                    ),
                    Text("collections", style: GoogleFonts.bungeeHairline(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.search, color: Colors.black),
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
              ],
            ),
          ),
          Expanded(child: SizedBox(height: 260.0, child: _buildBody(context))),
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
      stream:FirebaseFirestore.instance.collection('collectionNames').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
        }
        else {
          return (_width > 600)? _buildGridList(context, snapshot.data.docs) : _buildList(context, snapshot.data.docs);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
        crossAxisCount: 2,
        //itemExtent: 5,
        shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          children:[
            ...snapshot.map((data) => _buildListItem(context, data)).toList(),
          ]
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final collection = Collection.fromSnapshot(data);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Container(
          height: 250,
          width: double.infinity,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white54, width: 0.35),
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Color(0xffefefef),
            elevation: 5,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CollectionDetails(
                        collection: collection,
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
                      tag: collection.name,
                      child: Image.network(
                        collection.imgURL,
                        fit: BoxFit.fitHeight,
                        // height: 200,
                      ),
                    ),
                  ),
                  Container(
                    // constraints: BoxConstraints.expand(),
                    height: 500,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(collection.name, style: GoogleFonts.sarpanch(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.w300),),
                        SizedBox(height:16),


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