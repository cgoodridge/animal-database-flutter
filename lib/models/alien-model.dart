import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Alien {

  final String species;
  final String abilities;
  final String origin;
  final String codename;
  final String description;
  final Timestamp date;

  /// Color Variables
  final String environment;
  /// End of color variables


  ///TODO: REVIEW HOW DATE IS SORTED
  final bool isActive;
  final String imgUrl;
  final DocumentReference reference;

  Alien.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['species'] != null),
        assert(map['abilities'] != null),
        assert(map['origin'] != null),
        assert(map['codename'] != null),
        assert(map['description'] != null),
        assert(map['environment'] != null),
        assert(map['isActive'] != null),
        assert(map['imgURL'] != null),
        assert(map['dateAdded'] != null),
        species = map['species'],
        abilities = map['abilities'],
        origin = map['origin'],
        codename = map['codename'],
        description = map['description'],
        environment = map['environment'],
        isActive = map['isActive'],
        imgUrl = map['imgURL'],
        date = map['dateAdded'];

  Alien.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "$species:$abilities:$origin:$codename:$imgUrl";
  // String toString() => Alien<$species:$abilities:$origin:$codename:$imgUrl>";

  Map<String, dynamic> toJson() =>
      {
        'species': species,
        'abilities': abilities,
        'origin': origin,
        'codename': codename,
        'description': description,
        'environment': environment,
        'isActive': isActive,
        'imgURL': imgUrl,
        'dateAdded': date.toDate(),
      };

}