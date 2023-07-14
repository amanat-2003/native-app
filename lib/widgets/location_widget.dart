// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:places_app/key/all.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/screens/map_screen.dart';
import 'package:places_app/utils/maps_functions.dart';
import 'package:places_app/utils/show_snack_bar.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

class LocationWidget extends StatefulWidget {
  final void Function(PlaceLocation location) onSelectLocation;
  const LocationWidget({
    Key? key,
    required this.onSelectLocation,
  }) : super(key: key);

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  var _isLoading = false;

  PlaceLocation? placeLocation;
  String get _mapImageUrl {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${placeLocation!.latitude},${placeLocation!.longitude}'
        '&zoom=13&size=400x400&markers=color:blue%7Clabel:O%7C${placeLocation!.latitude},${placeLocation!.longitude}'
        '&key=$googleAPIKey';
  }

  void _selectLocation(LatLng? latLng) async {
    try {
      if (latLng == null) {
        throw Exception('Can not get the location data');
      }
      final fullAddress = await getFullAddress(latLng);
      if (fullAddress == null) {
        throw Exception('Can not get the full address');
      }
      setState(() {
        placeLocation = PlaceLocation(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
            address: fullAddress);
      });
      widget.onSelectLocation(placeLocation!);
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<LatLng?> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    return await getLatLng();
  }

  Future<LatLng?> _selectLocationOnMap() async {
    setState(() {
      _isLoading = true;
    });

    return await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (context) => const MapScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget buttons = Center(
      child: _isLoading
          ? Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      _selectLocation(await _getCurrentLocation());
                    },
                    icon: const Icon(Icons.place),
                    label: const Text(
                      'Get Current Location',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      _selectLocation(await _selectLocationOnMap());
                    },
                    icon: const Icon(Icons.travel_explore),
                    label: const Text(
                      'Select on Map',
                    ),
                  ),
                ],
              ),
            ),
    );

    Widget content = buttons;

    if (placeLocation != null) {
      content = Stack(children: [
        Image.network(
          _mapImageUrl,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        buttons,
      ]);
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1, color: Theme.of(context).colorScheme.onBackground),
      ),
      child: content,
    );
  }
}
