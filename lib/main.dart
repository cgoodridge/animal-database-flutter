import 'package:flutter/material.dart';
import 'package:omnitrix_database_flutter/models/user_model.dart';
import 'package:omnitrix_database_flutter/services/auth.dart';
import 'package:omnitrix_database_flutter/services/wrapper.dart';
import 'package:omnitrix_database_flutter/views/alien_details.dart';
import 'package:omnitrix_database_flutter/views/alienlist_screen.dart';
import 'package:omnitrix_database_flutter/views/collections_screen.dart';
import 'package:omnitrix_database_flutter/views/locations_screen.dart';
import 'package:omnitrix_database_flutter/views/login_screen.dart';
import 'package:omnitrix_database_flutter/views/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Omnitrix Database',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),

          initialRoute: '/',
          routes: {
            '/': (context) => Wrapper(),
            '/collections': (context) => CollectionsScreen(),
            '/locations': (context) => LocationsScreen(),
            '/home': (context) => MyHomePage(),
            '/settings': (context) => SettingsScreen(),
            AlienDetails.id: (context) => AlienDetails(),
            //'contacts_screen': (context) => AccountScreen(),
            //'balance_screen': (context) => BalanceScreen(),
            //'transfer_screen': (context) => TransferScreen()
          }
        //home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  final List<Widget> _navBarLocations = [
    AlienListScreen(),
    CollectionsScreen(),
    LocationsScreen(),
    SettingsScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      body: _navBarLocations[_selectedIndex],

      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        elevation: 0.1,
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Container(
          width: 100,
          height: 100,
          child:
              Icon(Icons.add, size: 30,),
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.green[600],
                    //Colors.transparent,
                    //Color(0x11000000)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
            ),
        ),

        backgroundColor: Colors.transparent,
      ): null,
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: Color(0xff212121),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'Collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Locations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
