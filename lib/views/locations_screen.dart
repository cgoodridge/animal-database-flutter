import 'dart:async';

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

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _firstLocation = CameraPosition(
    target: LatLng(25.284266, 14.438434),
    zoom: 12,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 800,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _firstLocation,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

}
