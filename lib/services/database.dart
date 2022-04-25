import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanctuary/models/animal-model.dart';
import 'package:sanctuary/models/user_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference animalCollection =
      FirebaseFirestore.instance.collection('animals');
  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');

  CustomUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUserData(
      uid: uid,
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      email: snapshot['email'],
      dateAdded: snapshot['dateAdded'].toDate(),
      role: snapshot['role'],
    );
  }

  Stream<CustomUserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future updateUserData(String firstName, String lastName) async {
    return await userCollection
        .doc(uid)
        .set({'firstName': firstName, 'lastName': lastName, 'role': 'user'});
  }

  Animal _animalDataFromSnapshot(DocumentSnapshot snapshot) {
    return Animal.fromSnapshot(snapshot);
  }

  Stream<QuerySnapshot> get animalData {
    return animalCollection.snapshots();
  }

  Stream<QuerySnapshot> get locationData {
    return locationCollection.snapshots();
  }
}
