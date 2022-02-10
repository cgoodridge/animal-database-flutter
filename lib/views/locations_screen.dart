import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/animal-model.dart';

class LocationsScreen extends StatefulWidget {
  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final TextEditingController searchController = new TextEditingController();

  bool isSearching = false;

  List _allResults = [];
  List _resultsList = [];

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
  onSearchChanged()
  {
    searchResultsList();
    print(searchController.text);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
                  child: !isSearching ? Text("Location", style: GoogleFonts.bungeeHairline(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),) :
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
                    },),

                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
