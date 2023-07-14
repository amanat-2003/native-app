// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/screens/loading_screen.dart';
import 'package:places_app/utils/maps_functions.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation? passedLocation;
  const MapScreen({
    Key? key,
    this.passedLocation,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _isLoading = true;

  void _getCurrentLocation() async {
    _currentLocation = await getLatLng();
  }

  @override
  void initState() {
    super.initState();
    if(widget.passedLocation == null) {
      _getCurrentLocation();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final toSelectLocation = widget.passedLocation == null ? true : false;
    final ifGotLocation = _currentLocation == null ? false : true;
    // final passedLocation = widget.passedLocation!;
    return _isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(toSelectLocation
                  ? 'Pick Your location'
                  : widget.passedLocation!.address),
              actions: [
                if(toSelectLocation)
                IconButton(
                    onPressed: () {
                      if(_selectedLocation != null) {
                        Navigator.of(context).pop(_selectedLocation);
                      }
                    },
                    icon: const Icon(Icons.check))
              ],
            ),
            body: GoogleMap(
              onTap: (position) {
                setState(() {
                  _selectedLocation = position;
                });
              },
              initialCameraPosition: CameraPosition(
                  target: toSelectLocation
                      ? (ifGotLocation
                          ? _currentLocation!
                          : const LatLng(37.3354, -121.8995))
                      : widget.passedLocation!.toLatLng(),
                  zoom: 16),
              markers: toSelectLocation
                  ? {
                      if (_selectedLocation != null)
                        Marker(
                          markerId: const MarkerId('m1'),
                          position: _selectedLocation!,
                        ),
                    }
                  : {
                      Marker(
                        markerId: const MarkerId('m2'),
                        position: widget.passedLocation!.toLatLng(),
                      ),
                    },
            ),
          );
  }
}

extension on PlaceLocation {
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
