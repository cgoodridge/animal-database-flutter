import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Location {
  final String locationName;
  final String locationColour;
  final Map coordinates;
  final List animalList;
  final DocumentReference reference;

  Location.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['locationColour'] != null),
        assert(map['name'] != null),
        assert(map['animals'] != null),
        assert(map['coordinates'] != null),
        locationColour = map['locationColour'],
        coordinates = map['coordinates'],
        animalList = map['animals'],
        locationName = map['name'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "$locationName:$locationColour";

  Map<String, dynamic> toJson() => {
        'name': locationName,
        'locationColour': locationColour,
        'coordinates': coordinates,
        'animals': animalList,
      };
}
