import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/providers/places_provider.dart';
import 'package:places_app/widgets/image_widget.dart';
import 'package:places_app/widgets/location_widget.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _placeLocation;

  void selectImage(File image) {
    _selectedImage = image;
  }

  void selectLocation(PlaceLocation location) {
    _placeLocation = location;
  }

  void _addPlace() {
    final name = _titleController.text;
    if (name.isEmpty || _selectedImage == null || _placeLocation == null) {
      return;
    }

    final placesNotifier = ref.read(placesProvider.notifier);

    placesNotifier.addPlace(
        Place(title: name, image: _selectedImage!, location: _placeLocation!));

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                controller: _titleController,
              ),
              const SizedBox(height: 15),
              ImageWidget(onSelectImage: selectImage),
              const SizedBox(height: 15),
              LocationWidget(onSelectLocation: selectLocation),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                  onPressed: _addPlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'))
            ],
          ),
        ),
      ),
    );
  }
}
