import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Animal {
  final String kingdomClass;
  final String family;
  final String genus;
  final String kingdom;
  final String order;
  final String phylum;
  final String scientificName;
  final String commonName;
  final String diet;
  final String lifespan;
  final String lifestyle;
  final List locations;
  // final String location;
  final String nameOfYoung;
  final String description;
  final String redListStatus;
  final String collection;
  final List imgURLS;

  // final List collections;
  final Timestamp date;

  /// Color Variables
  final String environment;

  /// End of color variables

  /// TODO: REVIEW HOW DATE IS SORTED
  // final bool isActive;
  final DocumentReference reference;

  Animal.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['kingdomClass'] != null),
        assert(map['family'] != null),
        assert(map['genus'] != null),
        assert(map['kingdom'] != null),
        assert(map['order'] != null),
        assert(map['phylum'] != null),
        assert(map['scientificName'] != null),
        assert(map['commonName'] != null),
        assert(map['diet'] != null),
        assert(map['lifespan'] != null),
        assert(map['lifestyle'] != null),
        // assert(map['locations'] != null),
        assert(map['nameOfYoung'] != null),
        assert(map['description'] != null),
        assert(map['redListStatus'] != null),
        assert(map['imgURLS'] != null),
        kingdomClass = map['kingdomClass'],
        family = map['family'],
        genus = map['genus'],
        kingdom = map['kingdom'],
        order = map['order'],
        phylum = map['phylum'],
        scientificName = map['scientificName'],
        commonName = map['commonName'],
        diet = map['diet'],
        lifespan = map['lifespan'],
        lifestyle = map['lifestyle'],
        locations = map['locations'],
        nameOfYoung = map['nameOfYoung'],
        description = map['description'],
        redListStatus = map['redListStatus'],
        collection = map['collection'],
        environment = map['environment'],
        imgURLS = map['imgURLS'],
        date = map['dateAdded'];

  Animal.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() =>
      "$kingdomClass:$family:$genus:$kingdom:$order:$phylum:$scientificName:$commonName:$redListStatus";

  Map<String, dynamic> toJson() => {
        'class': kingdomClass,
        'family': family,
        'genus': genus,
        'kingdom': kingdom,
        'order': order,
        'phylum': phylum,
        'scientificName': scientificName,
        'commonName': commonName,
        'diet': diet,
        'lifespan': lifespan,
        'lifestyle': lifestyle,
        'locations': locations,
        'description': description,
        'redListStatus': redListStatus,
        'nameOfYoung': nameOfYoung,
        // 'isActive': isActive,
        'imgURLS': imgURLS,
        'dateAdded': date.toDate(),
      };
}
