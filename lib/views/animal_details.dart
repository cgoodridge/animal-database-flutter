import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sanctuary/models/animal-model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanctuary/models/environment_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AnimalDetails extends StatelessWidget {
  static const String id = 'event_details';
  final Animal animal;
  final double widgetHeight = 350.0;

  AnimalDetails({this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeaeaea),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.black,
        title: Text(animal.scientificName, style: GoogleFonts.bungeeHairline(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),),
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         colors: <Color>[Colors.black, Colors.transparent]),
        //   ),
        //),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Hero(
              tag: animal.commonName,
              child: Image.network(animal.imgUrl, fit: BoxFit.fitHeight,)
          ),
          // _buildDetails(context),
          Expanded(
              child: _buildDetails(context)
          )
        ],
      )
      // SlidingUpPanel(
      //   minHeight: 350,
      //   maxHeight: MediaQuery.of(context).size.height,
      //   slideDirection: SlideDirection.DOWN,
      //   backdropEnabled: true,
      //   parallaxEnabled: true,
      //   borderRadius: BorderRadius.circular(20.0),
      //   color: Color(0xff2c2c2c),
      //   panel: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(top: 64.0),
      //         child: Align(
      //             child: Image.network(animal.imgUrl, fit: BoxFit.fitHeight,)
      //         ),
      //       ),
      //       Divider(
      //         height: 30,
      //         color: Colors.white70,
      //         thickness: 1,
      //         indent: 175,
      //         endIndent: 175,
      //       )
      //     ],
      //   ),
      //   body: Container(
      //     child: SafeArea(
      //       child: _buildDetails(context),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildDetails(BuildContext context)
  {
    return SafeArea(
        child: Column(
            children: <Widget>[
              Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        backgroundColor: Color(0xffffffff),
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(kToolbarHeight),
                          child: Container(
                            //color: Colors.green,
                            child: SafeArea(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                      child: Container()
                                  ),
                                  TabBar(
                                    isScrollable: true,
                                    indicatorColor: Colors.orange,
                                    tabs: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                                        child: Text("Description",
                                            style:  TextStyle(color: Colors.black)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0, top:15.0),
                                        child:Text("Classification",
                                            style:  TextStyle(color: Colors.black)
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 15.0, top:15.0),
                                      //   child:Text("Location & Habitat",
                                      //       style:  TextStyle(color: Colors.black)
                                      //   ),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 15.0, top:15.0),
                                      //   child:Text("Physical Characteristics",
                                      //       style:  TextStyle(color: Colors.black)
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        body: TabBarView(
                            children: [
                              ListView(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                                        child: Text(animal.description, style: TextStyle(height: 2,color: Colors.black),)
                                    ),
                                  ]
                              ),
                              ListView(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/5.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Kingdom', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text(animal.kingdom),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/4.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Phylum', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text(animal.phylum),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/7.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Class', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text(animal.kingdomClass),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/10.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Order', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text(animal.order),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Family', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text(animal.family),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Genus', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text(animal.genus),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Species', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text(animal.scientificName),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                  ]
                              ),
                              // ListView(
                              //     children: [
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/5.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Alessia', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("Growing Pains"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/4.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Hozier', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("To Be Alone"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/7.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Ariana', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("7 Rings"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/10.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Toby', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("Wilderman"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Beyonce', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("Halo"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //     ]
                              // ),
                              // ListView(
                              //     children: [
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/5.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Alessia', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("Growing Pains"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/4.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Hozier', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("To Be Alone"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/7.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Ariana', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("7 Rings"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/10.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Toby', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("Wilderman"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //       ListTile(
                              //         leading: CircleAvatar(
                              //           backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                              //           radius: 40,
                              //         ),
                              //         title: Text('Beyonce', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              //         subtitle: Text("Halo"),
                              //         trailing: Icon(Icons.more_vert),
                              //       ),
                              //     ]
                              // ),

                            ]
                        ),
                      )
                  )
              )
            ]
        )
    );
  }
}