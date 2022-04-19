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
  if (kIsWeb) {
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
  } else {
    await Firebase.initializeApp();
  }

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
      statusBarColor: Colors.orange,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarIconBrightness: Brightness.light,
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

    double _width = MediaQuery.of(context).size.width;

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
                    ? (_width > 600)
                        ? FloatingActionButton.extended(
                            elevation: 0.1,
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return FormDialog();
                                  });
                            },
                            label: const Text("Add Animal"),
                            icon: const Icon(Icons.add),
                            backgroundColor: Colors.orange,
                          )
                        : FloatingActionButton(
                            elevation: 0.1,
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return FormDialog();
                                  });
                            },
                            child: const Icon(Icons.add),
                            backgroundColor: Colors.orange,
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
                  backgroundColor: Color(0xffffffff),
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

  int _index = 0;

  File imgFile;
  String imgURL;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return AlertDialog(
      content: SizedBox(
        width: (_width > 600) ? 600 : (_width - 50),
        height: 600,
        child: Form(
          child: Stepper(
            elevation: 0.0,
            type: StepperType.horizontal,
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () {
              if (_index <= 0) {
                setState(() {
                  _index += 1;
                });
              }
            },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            steps: <Step>[
              Step(
                title: const Text('Animal Details'),
                content: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            child: TextFormField(
                              controller: kingdom,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Kingdom"),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: phylum,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Phylum"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: kingdomClass,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Class"),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: order,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Order"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: family,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Family"),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: genus,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Genus"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: scientificName,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Species"),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: commonName,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration:
                                  InputDecoration(hintText: "Common Name"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: nameOfYoung,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration:
                                  InputDecoration(hintText: "Name of Young"),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: diet,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Diet"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: lifespan,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration: InputDecoration(hintText: "Lifespan"),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: lifestyle,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration:
                                  InputDecoration(hintText: "LifeStyle"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: description,
                              validator: (value) {
                                return value.isNotEmpty
                                    ? null
                                    : "Invalid Field";
                              },
                              decoration:
                                  InputDecoration(hintText: "Description"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Step(
                title: Text('Images'),
                content: Text('Content for Step 2'),
              ),
              const Step(
                title: Text('Locations'),
                content: Text('Content for Step 2'),
              ),
              const Step(
                title: Text('Confirm & Upload'),
                content: Text('Content for Step 2'),
              ),
            ],
          ),
        ),
      ),
      // content: Flex(
      //   direction: Axis.vertical,
      //   children: [
      //     Stepper(
      //       currentStep: _index,
      //       onStepCancel: () {
      //         if (_index > 0) {
      //           setState(() {
      //             _index -= 1;
      //           });
      //         }
      //       },
      //       onStepContinue: () {
      //         if (_index <= 0) {
      //           setState(() {
      //             _index += 1;
      //           });
      //         }
      //       },
      //       onStepTapped: (int index) {
      //         setState(() {
      //           _index = index;
      //         });
      //       },
      //       steps: <Step>[
      //         Step(
      //           title: const Text('Step 1 title'),
      //           content: Container(
      //             width: 400,
      //             child: Form(
      //                 key: formKey,
      //                 child: Column(
      //                   children: [
      //                     // InkWell(
      //                     //     onTap: () {
      //                     //       getImage();
      //                     //     },
      //                     //     child: (imgFile != null)
      //                     //         ? Image.file(imgFile)
      //                     //         : CircleAvatar(
      //                     //             radius: 50,
      //                     //             backgroundColor: Colors.orange,
      //                     //             child: Icon(
      //                     //               Icons.camera_alt,
      //                     //               size: 50,
      //                     //               color: Colors.black,
      //                     //             ),
      //                     //           )),
      //                     // TextFormField(
      //                     //   controller: kingdom,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Kingdom"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: phylum,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Phylum"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: kingdomClass,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Class"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: order,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Order"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: family,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Family"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: genus,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Genus"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: scientificName,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration:
      //                     //       InputDecoration(hintText: "Scientific Name"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: commonName,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration:
      //                     //       InputDecoration(hintText: "Common Name"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: nameOfYoung,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration:
      //                     //       InputDecoration(hintText: "Name of Young"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: diet,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Diet"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: lifespan,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Lifespan"),
      //                     // ),
      //                     // TextFormField(
      //                     //   controller: lifestyle,
      //                     //   validator: (value) {
      //                     //     return value.isNotEmpty ? null : "Invalid Field";
      //                     //   },
      //                     //   decoration: InputDecoration(hintText: "Lifestyle"),
      //                     // ),
      //                     TextFormField(
      //                       controller: description,
      //                       validator: (value) {
      //                         return value.isNotEmpty ? null : "Invalid Field";
      //                       },
      //                       decoration:
      //                           InputDecoration(hintText: "Description"),
      //                     ),
      //                   ],
      //                 )),
      //           ),
      //         ),
      //         const Step(
      //           title: Text('Step 2 title'),
      //           content: Text('Content for Step 2'),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              addRecord();
              Navigator.of(context).pop();
            },
            child: Text(
              "Save",
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
      final image = await picker.pickImage(source: ImageSource.gallery);

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
