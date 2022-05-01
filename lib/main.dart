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
import 'package:sanctuary/utils/dark_theme_styles.dart';
import 'package:sanctuary/utils/dart_theme_provider.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await dotenv.load(fileName: ".env");

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
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.orange,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarIconBrightness: Brightness.light,
    ));
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return StreamProvider<CustomUser>.value(
            value: AuthService().user,
            initialData: null,
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Project Sanctuary',
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                // theme: Styles.themeData(themeChangeProvider.darkTheme, context),
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

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final userAnon = FirebaseAuth.instance.currentUser.isAnonymous;

  int _selectedIndex =  0;


  //PickedFile image;

  final List<Widget> _navBarLocations = [
    AnimalListScreen(),
    CollectionsScreen(),
    LocationsScreen(),
    SettingsScreen(),
  ];
  final List<Widget> _anonNavBarLocations = [
    AnimalListScreen(),
    LocationsScreen(),
    SettingsScreen(),
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
    final themeChange = Provider.of<DarkThemeProvider>(context);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom, //This line is used for showing the bottom bar
    ]);

    double _width = MediaQuery.of(context).size.width;
    return StreamBuilder<CustomUserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          // print(user.toString());
          if (snapshot.hasData || user.uid != null) {
            CustomUserData userData = snapshot.data;
            if (userData != null && userData.role == 'admin') {
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
                  // backgroundColor: Color(0xfff1f1f1),
                  unselectedItemColor: themeChange.darkTheme ? Colors.white : Colors.black,
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
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
                  selectedItemColor: Colors.orange,
                  onTap: _onItemTapped,
                ),
              );
            } else {
              if (userAnon) {
                return Scaffold(
                  extendBody: true,
                  body: _anonNavBarLocations[_selectedIndex],
                  //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: BottomNavigationBar(
                    // backgroundColor: Color(0xffffffff),
                    unselectedItemColor: themeChange.darkTheme ? Colors.white : Colors.black,
                    type: BottomNavigationBarType.fixed,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
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
                    // backgroundColor: Color(0xffffffff),
                    unselectedItemColor: themeChange.darkTheme ? Colors.white : Colors.black,
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
                    selectedItemColor: Colors.orange,
                    onTap: _onItemTapped,
                  ),
                );
              }

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

  Widget _eventControlBuilder(BuildContext context, ControlsDetails controls) {
    return Row(
      children: [
        TextButton(
          onPressed: controls.onStepContinue,
          child: const Text('Next'),
        ),
        TextButton(
          onPressed: controls.onStepCancel,
          child: const Text('Back'),
        ),
      ],
    );
  }

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
            onStepCancel:
                _index == 0 ? null : () => setState(() => _index -= 1),
            onStepContinue: () {
              final isLastStep = _index == 3;
              if (isLastStep) {
                print("Completed");
                // Save Animal
              } else {
                setState(() => _index += 1);
              }
            },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            controlsBuilder: _eventControlBuilder,
            steps: <Step>[
              Step(
                state: _index > 0 ? StepState.complete : StepState.indexed,
                isActive: _index >= 0,
                title: const Text('Animal Details'),
                content: Flex(
                  direction: Axis.vertical,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            child: TextFormField(
                              controller: kingdom,
                              validator: (val) =>
                              val.isEmpty ? "Enter a Kingdom" : null,
                              decoration: InputDecoration(hintText: "Kingdom"),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: phylum,
                              validator: (val) =>
                              val.isEmpty ? "Enter a Phylum" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a Class" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a Order" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a Family" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a Genus" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a Species" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a Common Name" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter name of young" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter diet" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a lifespan" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter lifestyle" : null,
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
                              validator: (val) =>
                              val.isEmpty ? "Enter a description" : null,
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
              Step(
                state: _index > 1 ? StepState.complete : StepState.indexed,
                isActive: _index >= 1,
                title: Text('Images'),
                content: Text('Image selector goes here'),
              ),
              Step(
                state: _index > 2 ? StepState.complete : StepState.indexed,
                isActive: _index >= 2,
                title: Text('Locations'),
                content: Text('Map goes here'),
              ),
              Step(
                state: _index > 3 ? StepState.complete : StepState.indexed,
                isActive: _index >= 3,
                title: Text('Confirm & Upload'),
                content: Text('Content for Step 4'),
              ),
            ],
          ),
        ),
      ),
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
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection("locations")
            .doc(location.text)
            .update({
          'locationName': "",
          'animals': [
            {
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
            }
          ],
        });
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
