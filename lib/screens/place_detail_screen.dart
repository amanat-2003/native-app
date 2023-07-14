import 'package:flutter/material.dart';
import 'package:places_app/key/all.dart';

import 'package:places_app/models/place.dart';
import 'package:places_app/screens/map_screen.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  String get _mapImageUrl {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${place.location.latitude},${place.location.longitude}'
        '&zoom=13&size=400x400&markers=color:blue%7Clabel:O%7C${place.location.latitude},${place.location.longitude}'
        '&key=$googleAPIKey';
  }

  const PlaceDetailScreen({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    place.location.latitude.log();
    place.location.longitude.log();
    place.location.address.log();
    _mapImageUrl.log();
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Stack(children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MapScreen(passedLocation: place.location),
                      ));
                    },
                    child: CircleAvatar(
                      foregroundImage: NetworkImage(_mapImageUrl),
                      radius: 80,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    ),
                    child: Text(
                      place.location.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                ],
              )),
        ]));
  }
}
