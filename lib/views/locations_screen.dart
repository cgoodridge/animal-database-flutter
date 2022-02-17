import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanctuary/models/user_model.dart';
import 'package:provider/provider.dart';
import '../models/animal-model.dart';
import '../services/database.dart';

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

  static const LatLng showLocation = const LatLng(7.71099, 26.104868);
  final Set<Marker> markers = new Set();

  static final CameraPosition _firstLocation = CameraPosition(
    target: LatLng(7.710992, 26.104868),
    zoom: 0,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<CustomUser>(context);

    return StreamBuilder<CustomUserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
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
                  TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.location_on_rounded, color: Colors.black,)),
                        Tab(icon: Icon(Icons.map, color: Colors.black,)),
                      ]
                  ),
                  Expanded(
                    child: TabBarView(
                        children: [
                          ExpansionTile(
                              title: Text("test")
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: SizedBox(
                              height: 800,
                              child: GoogleMap(
                                mapType: MapType.hybrid,
                                compassEnabled: true,
                                markers: getMarkers(),
                                initialCameraPosition: _firstLocation,
                                onMapCreated: (GoogleMapController controller) {
                                  setState(() {
                                    _controller.complete(controller);
                                  });
                                },
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Set<Marker> getMarkers() { //markers to place on map

    markers.add(Marker( //add first marker
      markerId: MarkerId(showLocation.toString()),
      position: showLocation, //position of marker
      infoWindow: InfoWindow( //popup info
        title: 'Aardvark',
        snippet: 'Oryteropus Afer',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    return markers;
  }

}
