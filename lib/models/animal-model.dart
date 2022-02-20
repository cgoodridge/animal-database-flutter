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
  final String location;
  final String nameOfYoung;
  final String description;
  final String redListStatus;
  final List collections;
  final Timestamp date;

  /// Color Variables
  final String environment;
  /// End of color variables

  /// TODO: REVIEW HOW DATE IS SORTED
  // final bool isActive;
  final String imgUrl;
  final DocumentReference reference;

  Animal.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['class'] != null),
        assert(map['family'] != null),
        assert(map['genus'] != null),
        assert(map['kingdom'] != null),
        assert(map['order'] != null),
        assert(map['phylum'] != null),
        assert(map['scientific-name'] != null),
        assert(map['common-name'] != null),
        assert(map['diet'] != null),
        assert(map['lifespan'] != null),
        assert(map['lifestyle'] != null),
        assert(map['location'] != null),
        assert(map['name-of-young'] != null),
        assert(map['description'] != null),
        assert(map['redlist-status'] != null),
        kingdomClass = map['class'],
        family = map['family'],
        genus = map['genus'],
        kingdom = map['kingdom'],
        order = map['order'],
        phylum = map['phylum'],
        scientificName = map['scientific-name'],
        commonName = map['common-name'],
        diet = map['diet'],
        lifespan = map['lifespan'],
        lifestyle = map['lifestyle'],
        location = map['location'],
        nameOfYoung = map['name-of-young'],
        description = map['description'],
        redListStatus = map['redlist-status'],
        collections = map['collections'],
        environment = map['environment'],
        imgUrl = map['imgURL'],
        date = map['dateAdded'];

  Animal.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "$kingdomClass:$family:$genus:$kingdom:$order:$phylum:$scientificName:$commonName:$imgUrl:$redListStatus";

  Map<String, dynamic> toJson() => {
    'class': kingdomClass,
    'family': family,
    'genus': genus,
    'kingdom': kingdom,
    'order': order,
    'phylum': phylum,
    'scientific-name': scientificName,
    'common-name': commonName,
    'diet': diet,
    'lifespan': lifespan,
    'lifestyle': lifestyle,
    'location': location,
    'description': description,
    'redlist-status': redListStatus,
    'name-of-young': nameOfYoung,
    // 'isActive': isActive,
    'imgURL': imgUrl,
    'dateAdded': date.toDate(),
  };
}