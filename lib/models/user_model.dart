import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String uid;
  CustomUser({this.uid});
}

class CustomUserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateAdded;
  final String role;

  final DocumentReference reference;

  CustomUserData(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.dateAdded,
      this.role,
      this.reference});

  // CustomUserData.fromMap(Map<String, dynamic> map, {this.reference})
  //     : assert(map['first-name'] != null),
  //       assert(map['last-name'] != null),
  //       assert(map['role'] != null),
  //       uid = map['uid'],
  //       firstName = map['first-name'],
  //       lastName = map['last-name'],
  //       role = map['role'];
  //
  // CustomUserData.fromSnapshot(DocumentSnapshot snapshot)
  //     : this.fromMap(snapshot.data(), reference: snapshot.reference);
  //
  // @override
  // String toString() => "$firstName:$lastName";

}
