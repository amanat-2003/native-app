import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart';
import 'package:places_app/key/all.dart';

Future<LatLng?> getLatLng() async {
  Location location = Location();

  var serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  var permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  final locationData = await location.getLocation();
  if (locationData.latitude == null || locationData.longitude == null) {
    return null;
  }

  return LatLng(locationData.latitude!, locationData.longitude!);
}

Future<String?> getFullAddress(LatLng latLng) async {
  final lat = latLng.latitude;
  final lng = latLng.longitude;

  final reverseGeocodingAPI = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleAPIKey');

  final response = await http.get(reverseGeocodingAPI);
  // response.body.log();
  return json.decode(response.body)["results"][0]["formatted_address"];
}
