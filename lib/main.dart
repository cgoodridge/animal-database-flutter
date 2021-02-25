import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

void main() {
  bool realLife = false;
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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

  //PickedFile image;

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
        onPressed: () async {
          showDialog(
              context: context,
              builder: (_){
                return FormDialog();
            });

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

class FormDialog extends StatefulWidget {
  @override
  _FormDialogState createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {

  final formKey = GlobalKey<FormState>();

  final TextEditingController species = TextEditingController();
  final TextEditingController codename = TextEditingController();
  final TextEditingController environment = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController abilities = TextEditingController();
  final TextEditingController origin = TextEditingController();

  File imgFile;
  String imgURL;
  @override
  Widget build(BuildContext context) {

      return AlertDialog(
      content: Container(
        width: double.maxFinite,
        child: ListView(
            shrinkWrap: true,
            children:[
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InkWell(
                          onTap:() {
                            getImage();
                          },
                          child: (imgFile != null) ? Image.file(imgFile): CircleAvatar(radius: 50, backgroundColor: Colors.transparent,)
                      ),
                      TextFormField(
                        controller: species,
                        validator: (value){
                          return value.isNotEmpty? null : "Invalid Field";
                        },
                        decoration: InputDecoration(
                            hintText: "Species"
                        ),
                      ),
                      TextFormField(
                        controller: codename,
                        validator: (value){
                          return value.isNotEmpty? null : "Invalid Field";
                        },
                        decoration: InputDecoration(
                            hintText: "Codename"
                        ),
                      ),
                      TextFormField(
                        controller: environment,
                        validator: (value){
                          return value.isNotEmpty? null : "Invalid Field";
                        },
                        decoration: InputDecoration(
                            hintText: "Environment"
                        ),
                      ),
                      TextFormField(
                        controller: description,
                        validator: (value){
                          return value.isNotEmpty? null : "Invalid Field";
                        },
                        decoration: InputDecoration(
                            hintText: "Description"
                        ),
                      ),
                      TextFormField(
                        controller: abilities,
                        validator: (value){
                          return value.isNotEmpty? null : "Invalid Field";
                        },
                        decoration: InputDecoration(
                            hintText: "Abilities"
                        ),
                      ),
                      TextFormField(
                        controller: origin,
                        validator: (value){
                          return value.isNotEmpty? null : "Invalid Field";
                        },
                        decoration: InputDecoration(
                            hintText: "Origin"
                        ),
                      ),
                    ],
                  )
              ),
            ]
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: (){
              addRecord();
              Navigator.of(context).pop();
            },
            child: Text("Submit")
        )
      ],
    );

  }

  void addRecord() async
  {
    if (formKey.currentState.validate())
      {
        var imageStore = FirebaseStorage.instance.ref().child(imgFile.path);
        var imageUploadTask = imageStore.putFile(imgFile);

        imgURL = await (await imageUploadTask.onComplete).ref.getDownloadURL();

        await Firestore.instance.collection("aliens").add({
          'abilities' : abilities.text,
          'codename' : codename.text,
          'dateAdded' : DateTime.now(),
          'description' : description.text,
          'environment' : environment.text,
          'imgURL' : imgURL,
          'isActive' : false,
          'origin' : origin.text,
          'species' : species.text,
        });
      }

  }


  void getImage() async
  {
    final picker = ImagePicker();

    //Check permissions
    await Permission.photos.request();
    await Permission.camera.request();

    var photoPermissionStatus = await Permission.photos.status;
    //var cameraPermissionStatus = await Permission.camera.status;

    if(photoPermissionStatus.isGranted)
    {
      final image = await picker.getImage(source: ImageSource.gallery);

      //var file = ;
      //print(file);
      if(image != null){
        setState(() {
          imgFile = File(image.path);
        });
      }
      else {
        print("No path received");
      }
    }
    else{
      print("Permission needs to be granted");
    }

  }
}
