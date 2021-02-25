import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Collection {

  final String name;

  final DocumentReference reference;

  Collection.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];


  Collection.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "$name";
  // String toString() => Alien<$species:$abilities:$origin:$codename:$imgUrl>";


}