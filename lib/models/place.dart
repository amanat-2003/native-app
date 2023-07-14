// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  Place copyWith({
    String? id,
    String? title,
    File? image,
    PlaceLocation? location,
  }) {
    return Place(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      location: location ?? this.location,
    );
  }
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;
  PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
