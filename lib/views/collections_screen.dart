import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omnitrix_database_flutter/models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:omnitrix_database_flutter/models/collection_model.dart';
import 'alien_details.dart';
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
                    Text("collections", style: GoogleFonts.bungeeHairline(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),
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
      stream:Firestore.instance.collection('playlistNames').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        else {
          return (_width > 600)? _buildGridList(context, snapshot.data.documents) : _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(

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

    //CollectionReference favorite = Firestore.instance.collection('favourites');

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(collection.name, style: GoogleFonts.sarpanch(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),)
            ),
            SizedBox(height: 8,),
            Container(
              height: 220,
              width: 350,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white54, width: 0.35),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Color(0xff363636),
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
                  child: Container(
                    child: Column(
                      children: [
                      ],
                    ),
                  ),
                )
              ),
            ),
          ],
        )
    );
  }
}