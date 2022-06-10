import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sanctuary/models/animal-model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/models/location_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AnimalDetails extends StatelessWidget {
  static const String id = 'animal_details';
  final Animal animal;
  final double widgetHeight = 350.0;

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = new Set();
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  static final CameraPosition _firstLocation = CameraPosition(
    target: LatLng(7.710992, 26.104868),
    zoom: 3,
  );

  AnimalDetails({this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text(
            animal.commonName,
            style: GoogleFonts.bungeeHairline(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Hero(
                tag: animal.commonName,
                child: Container(
                  height: 300,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        ...animal.imgURLS.map((data) =>
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: 200,
                                  minHeight: 200,
                                  maxWidth: 350,
                                  maxHeight: 350),
                              child: Image.network(
                                data,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            // _buildDetails(context),
            Expanded(
                child: _buildDetails(context)
            )
          ],
        ));
  }

  Widget _buildDetails(BuildContext context) {
    return SafeArea(
      child: Column(
          children: <Widget>[
      Expanded(
          child: DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Container(
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          Expanded(child: Container()),
                          TabBar(
                            isScrollable: true,
                            indicatorColor: Colors.orange,
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15.0, top: 15.0),
                                child: Text("Description"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15.0, top: 15.0),
                                child: Text("Classification"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15.0, top: 15.0),
                                child: Text("Habitat"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15.0, top: 15.0),
                                child: Text("Details"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: TabBarView(children: [
                  Flexible(
                    child: ListView(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 20.0),
                          child: Text(
                            animal.description,
                            style: TextStyle(height: 2),
                          )),
                    ]),
                  ),
                  ListView(children: [
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Kingdom:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.kingdom),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Phylum:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.phylum),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Class:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.kingdomClass),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Order:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.order),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Family:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.family),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Genus:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.genus),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Species:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.scientificName),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              "Common Name:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.commonName),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  ]),
                  ListView(children: [
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text("Locations: "),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text("animal.location"),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 800,
                      width: 600,
                      child: GoogleMap(
                        onTap: (position) {
                          _customInfoWindowController.hideInfoWindow();
                        },
                        mapType: MapType.hybrid,
                        compassEnabled: true,
                        onCameraMove: (position) {
                          _customInfoWindowController
                              .onCameraMove();
                        },
                        markers: getMarkers(animal.locations),
                        initialCameraPosition: _firstLocation,
                        onMapCreated: (GoogleMapController
                        controller) async {
                          _customInfoWindowController
                              .googleMapController = controller;
                        },
                      ),
                    )
                  ]),
                  ListView(children: [
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text("Lifespan:"),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.lifespan),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text("Lifestyle:"),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.lifestyle),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text("Name of Young:"),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.nameOfYoung),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text("Diet:"),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.diet),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text("Red List Status:"),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(animal.redListStatus),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  ]),
                ]),
              )))
    ]));
  }

  Set<Marker> getMarkers(List locations) {
    //markers to place on map
    // final animalData = Animal.fromSnapshot(animal);
    // final locationData = Location.fromSnapshot(location.first);

    locations.forEach((data) {
      print(data);
      markers.add(Marker(
          markerId: MarkerId(data["lat"].toString()),
          position: LatLng(data["lat"], data["lng"]),
          onTap: () {
            // _customInfoWindowController.addInfoWindow(
            //
            //   LatLng(double.parse(data.get("latitude")),
            //       double.parse(data.get("longitude"))),
            // );
          },
        ));
      }
    );

    return markers;
  }
}

