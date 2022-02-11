import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Collection {

  final String name;
  final String imgURL;

  final DocumentReference reference;

  Collection.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
      assert(map['imgURL'] != null),
      name = map['name'],
      imgURL = map['imgURL'];


  Collection.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "$name:$imgURL";

  // String toString() => Alien<$species:$abilities:$origin:$codename:$imgUrl>";


}