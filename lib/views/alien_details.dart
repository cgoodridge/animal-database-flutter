import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omnitrix_database_flutter/models/alien-model.dart';
import 'package:omnitrix_database_flutter/models/environment_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class AlienDetails extends StatelessWidget {
  static const String id = 'event_details';
  final Alien alien;
  final double widgetHeight = 350.0;

  AlienDetails({this.alien});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1a1a),
      body: SlidingUpPanel(
        minHeight: 350,
        maxHeight: MediaQuery.of(context).size.height,
        slideDirection: SlideDirection.DOWN,
        backdropEnabled: true,
        parallaxEnabled: true,
        borderRadius: BorderRadius.circular(20.0),
        color: Color(0xff2c2c2c),
        panel: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: Align(
                  child: Image.network(alien.imgUrl, height: 350,)
              ),
            ),
            Divider(
              height: 30,
              color: Colors.white70,
              thickness: 1,
              indent: 175,
              endIndent: 175,
            )
          ],
        ),
        body: Container(
          child: SafeArea(
            child: _buildDetails(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context)
  {
    return SafeArea(
        child: Column(
            children: <Widget>[
              SizedBox(height: (MediaQuery.of(context).size.height) - widgetHeight),
              Expanded(
                  child: DefaultTabController(
                      length: 4,
                      child: Scaffold(
                        backgroundColor: Color(0xff1a1a1a),
                        appBar: new PreferredSize(
                          preferredSize: Size.fromHeight(kToolbarHeight),
                          child: new Container(
                            //color: Colors.green,
                            child: new SafeArea(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                      child: new Container()
                                  ),
                                  TabBar(
                                    isScrollable: true,
                                    indicatorColor: Colors.green,
                                    tabs: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                                        child: Text("Classification",
                                            style:  TextStyle(color: Colors.white70)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0, top:15.0),
                                        child:Text("Locations",
                                            style:  TextStyle(color: Colors.white70)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0, top:15.0),
                                        child:Text("Facts",
                                            style:  TextStyle(color: Colors.white70)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15.0, top:15.0),
                                        child:Text("Physical Characteristics",
                                            style:  TextStyle(color: Colors.white70)
                                        ),
                                      ),
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
                                        child: Text(alien.description, style: TextStyle(height: 2,color: Colors.white70),)
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
                                      title: Text('Alessia', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Growing Pains"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/4.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Hozier', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("To Be Alone"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/7.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Ariana', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("7 Rings"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/10.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Toby', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Wilderman"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Beyonce', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Halo"),
                                      trailing: Icon(Icons.more_vert),
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
                                      title: Text('Alessia', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Growing Pains"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/4.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Hozier', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("To Be Alone"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/7.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Ariana', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("7 Rings"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/10.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Toby', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Wilderman"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Beyonce', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Halo"),
                                      trailing: Icon(Icons.more_vert),
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
                                      title: Text('Alessia', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Growing Pains"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/4.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Hozier', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("To Be Alone"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/7.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Ariana', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("7 Rings"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/10.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Toby', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Wilderman"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/45.jpg"),
                                        radius: 40,
                                      ),
                                      title: Text('Beyonce', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      subtitle: Text("Halo"),
                                      trailing: Icon(Icons.more_vert),
                                    ),
                                  ]
                              ),

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
