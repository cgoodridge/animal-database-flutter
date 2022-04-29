import 'dart:async';
import 'package:clippy_flutter/triangle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sanctuary/models/user_model.dart';
import 'package:provider/provider.dart';
import '../models/animal-model.dart';
import '../models/location_model.dart';
import '../services/database.dart';
import 'animal_details.dart';
import 'package:custom_info_window/custom_info_window.dart';

class LocationsScreen extends StatefulWidget {
  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final TextEditingController searchController = new TextEditingController();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  bool isSearching = false;

  List _allResults = [];
  List _resultsList = [];

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

  onSearchChanged() {
    searchResultsList();
    print(searchController.text);
  }

  @override
  void initState() {
    _customInfoWindowController.dispose();
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

    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().locationData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Color(0xffffffff),
                body: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
                                    "Location",
                                    style: GoogleFonts.bungeeHairline(
                                        color: Colors.black,
                                        fontSize: 28,
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
                                        hintStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              color: Colors.black,
                              icon: !isSearching
                                  ? Icon(Icons.search)
                                  : Icon(Icons.cancel),
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
                      TabBar(tabs: [
                        Tab(
                            icon: Icon(
                          Icons.location_on_rounded,
                          color: Colors.black,
                        )),
                        Tab(
                            icon: Icon(
                          Icons.map,
                          color: Colors.black,
                        )),
                      ]),
                      Expanded(
                        child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildList(context, snapshot.data.docs),
                              // Text("Test")
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32.0),
                                    child: SizedBox(
                                      height: 800,
                                      child: GoogleMap(
                                        onTap: (position) {
                                          _customInfoWindowController
                                              .hideInfoWindow();
                                        },
                                        mapType: MapType.hybrid,
                                        compassEnabled: true,
                                        onCameraMove: (position) {
                                          _customInfoWindowController
                                              .onCameraMove();
                                        },
                                        markers: getMarkers(snapshot.data.docs.first),
                                        initialCameraPosition: _firstLocation,
                                        onMapCreated: (GoogleMapController
                                            controller) async {
                                          _customInfoWindowController
                                              .googleMapController = controller;
                                        },
                                      ),
                                    ),
                                  ),
                                  // _buildMapPanel(context, snapshot.data.docs),
                                  CustomInfoWindow(
                                    controller: _customInfoWindowController,
                                    height: 75,
                                    width: 150,
                                    offset: 30,
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: [
        ...snapshot.map((data) => _buildListItem(context, data)).toList(),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final location = Location.fromSnapshot(data);
    return ExpansionTile(
      title: Text(location.locationName),
      children: [
        Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ...location.animalList.map((animalData) {
                  final animal = Animal.fromMap(animalData);
                  return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(animal.imgURLS.first),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimalDetails(
                                      animal: animal,
                                    )),
                          );
                        },
                      ),
                      title: Text(animal.commonName));
                }).toList()
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMapPanel(BuildContext context, DocumentSnapshot data) {
    final location = Location.fromSnapshot(data);
    return ExpansionTile(
      title: Text(location.locationName),
      children: [
        Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ...location.animalList.map((animalData) {
                  final animal = Animal.fromMap(animalData);
                  return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(animal.imgURLS.first),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimalDetails(
                                  animal: animal,
                                )),
                          );
                        },
                      ),
                      title: Text(animal.commonName));
                }).toList()
              ],
            ),
          ],
        ),
      ],
    );
  }


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Set<Marker> getMarkers(DocumentSnapshot location) {
    //markers to place on map
    print(location);
    // final animalData = Animal.fromSnapshot(animal);
    // final locationData = Location.fromSnapshot(location.first);

    //location.forEach((data) {
      // print(data.get("common-name"));
      // final location = Location.fromSnapshot(data);
      // final animal = Animal.fromSnapshot(data);

      // markers.add(Marker(
      //   markerId: MarkerId(data.get("commonName")),
      //   position: LatLng(double.parse(data.get("lat")),
      //       double.parse(data.get("lng"))),
      //   onTap: () {
      //     _customInfoWindowController.addInfoWindow(
      //       Column(
      //         children: [
      //           Expanded(
      //             child: InkWell(
      //               onTap: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => AnimalDetails(
      //                             animal: animal,
      //                           )),
      //                 );
      //               },
      //               child: Container(
      //                 decoration: BoxDecoration(
      //                   color: Colors.blue,
      //                   borderRadius: BorderRadius.circular(4),
      //                 ),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       CircleAvatar(
      //                           backgroundImage:
      //                               NetworkImage(data.get("imgURL"))),
      //                       SizedBox(
      //                         width: 8.0,
      //                       ),
      //                       Text(
      //                         data.get("commonName"),
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .headline6
      //                             .copyWith(
      //                               color: Colors.white,
      //                             ),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 width: double.infinity,
      //                 height: double.infinity,
      //               ),
      //             ),
      //           ),
      //           Triangle.isosceles(
      //             edge: Edge.BOTTOM,
      //             child: Container(
      //               color: Colors.blue,
      //               width: 20.0,
      //               height: 10.0,
      //             ),
      //           ),
      //         ],
      //       ),
      //       LatLng(double.parse(data.get("latitude")),
      //           double.parse(data.get("longitude"))),
      //     );
      //   },
      // ));
    //});

    return markers;
  }
}
