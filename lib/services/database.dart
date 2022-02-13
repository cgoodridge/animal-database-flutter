import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanctuary/models/user_model.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  CustomUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUserData(
      uid: uid,
      firstName: snapshot['first-name'],
      lastName: snapshot['last-name'],
      role: snapshot['role'],
    );
  }

  Stream<CustomUserData> get userData {
    return userCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }
}