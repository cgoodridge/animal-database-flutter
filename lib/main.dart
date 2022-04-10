import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanctuary/models/user_model.dart';
import 'package:sanctuary/services/auth.dart';
import 'package:sanctuary/services/database.dart';
import 'package:sanctuary/services/wrapper.dart';
import 'package:sanctuary/views/animal_details.dart';
import 'package:sanctuary/views/animallist_screen.dart';
import 'package:sanctuary/views/collections_screen.dart';
import 'package:sanctuary/views/account_screen.dart';
import 'package:sanctuary/views/locations_screen.dart';
import 'package:sanctuary/views/login_screen.dart';
import 'package:sanctuary/views/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCGS7aJ--tZICb9zBfCqWEy2pwCc-roDc8",
      appId: "1:553317843027:web:89d438c60e5b2184e446a6",
      messagingSenderId: "553317843027",
      projectId: "natgeo-database",
      storageBucket: "natgeo-database.appspot.com",
      authDomain: "natgeo-database.firebaseapp.com",
      measurementId: "G-3P0R5F60ZD",
    ),
  );

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print(AuthService().currentUser);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.orange
    ));
    return StreamProvider<CustomUser>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Project Sanctuary',
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
            AnimalDetails.id: (context) => AnimalDetails(),
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
    AnimalListScreen(),
    CollectionsScreen(),
    LocationsScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom, //This line is used for showing the bottom bar
    ]);

    return StreamBuilder<CustomUserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CustomUserData userData = snapshot.data;
            if (userData.role == 'admin') {
              return Scaffold(
                extendBody: true,
                body: _navBarLocations[_selectedIndex],
                floatingActionButton: _selectedIndex == 0
                    ? FloatingActionButton(
                        elevation: 0.1,
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return FormDialog();
                              });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.orange,
                                    Colors.orange,
                                    //Colors.transparent,
                                    //Color(0x11000000)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                        ),
                        backgroundColor: Colors.transparent,
                      )
                    : null,
                //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Color(0xfff1f1f1),
                  unselectedItemColor: Colors.black,
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
                      icon: Icon(Icons.person),
                      label: 'Account',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.orange,
                  onTap: _onItemTapped,
                ),
              );
            } else {
              return Scaffold(
                extendBody: true,
                body: _navBarLocations[_selectedIndex],
                //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Color(0xffe3e3e3),
                  unselectedItemColor: Colors.black,
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
                      icon: Icon(Icons.person),
                      label: 'Account',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.orange,
                  onTap: _onItemTapped,
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class FormDialog extends StatefulWidget {
  @override
  _FormDialogState createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final formKey = GlobalKey<FormState>();
  /*
  * TODO: Add remaining fields
  * */
  final TextEditingController kingdomClass = TextEditingController();
  final TextEditingController family = TextEditingController();
  final TextEditingController genus = TextEditingController();
  final TextEditingController kingdom = TextEditingController();
  final TextEditingController order = TextEditingController();
  final TextEditingController phylum = TextEditingController();
  final TextEditingController scientificName = TextEditingController();
  final TextEditingController commonName = TextEditingController();
  final TextEditingController nameOfYoung = TextEditingController();
  final TextEditingController diet = TextEditingController();
  final TextEditingController lifespan = TextEditingController();
  final TextEditingController lifestyle = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();

  File imgFile;
  String imgURL;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        child: ListView(shrinkWrap: true, children: [
          Form(
              key: formKey,
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: (imgFile != null)
                          ? Image.file(imgFile)
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.orange,
                              child: Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.black,
                              ),
                            )),
                  TextFormField(
                    controller: kingdom,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Kingdom"),
                  ),
                  TextFormField(
                    controller: phylum,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Phylum"),
                  ),
                  TextFormField(
                    controller: kingdomClass,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Class"),
                  ),
                  TextFormField(
                    controller: order,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Order"),
                  ),
                  TextFormField(
                    controller: family,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Family"),
                  ),
                  TextFormField(
                    controller: genus,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Genus"),
                  ),
                  TextFormField(
                    controller: scientificName,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Scientific Name"),
                  ),
                  TextFormField(
                    controller: commonName,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Common Name"),
                  ),
                  TextFormField(
                    controller: nameOfYoung,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Name of Young"),
                  ),
                  TextFormField(
                    controller: diet,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Diet"),
                  ),
                  TextFormField(
                    controller: lifespan,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Lifespan"),
                  ),
                  TextFormField(
                    controller: lifestyle,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Lifestyle"),
                  ),
                  TextFormField(
                    controller: description,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                ],
              )),
        ]),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              addRecord();
              Navigator.of(context).pop();
            },
            child: Text(
              "SAVE",
              style: TextStyle(fontSize: 22),
            ))
      ],
    );
  }

  void addRecord() async {
    final user = Provider.of<CustomUser>(context);

    if (formKey.currentState.validate()) {
      var imageStore = FirebaseStorage.instance.ref().child(imgFile.path);
      var imageUploadTask = imageStore.putFile(imgFile);

      imgURL = await (await imageUploadTask).ref.getDownloadURL();

      await FirebaseFirestore.instance.collection("animals").add({
        'kingdom': kingdom.text,
        'phylum': phylum.text,
        'class': kingdomClass.text,
        'order': order.text,
        'family': family.text,
        'genus': genus.text,
        'scientificName': scientificName.text,
        'commonName': commonName.text,
        'addedBy': user.uid,
        'location': location.text,
        'imgURL': imgURL,
        'dateAdded': DateTime.now(),
      });
    }
  }

  void getImage() async {
    final picker = ImagePicker();

    //Check permissions
    await Permission.photos.request();
    await Permission.camera.request();

    var photoPermissionStatus = await Permission.photos.status;
    //var cameraPermissionStatus = await Permission.camera.status;

    if (photoPermissionStatus.isGranted) {
      final image = await picker.getImage(source: ImageSource.gallery);

      //var file = ;
      //print(file);
      if (image != null) {
        setState(() {
          imgFile = File(image.path);
        });
      } else {
        print("No path received");
      }
    } else {
      print("Permission needs to be granted");
    }
  }
}
