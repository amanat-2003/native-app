import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places_app/models/place.dart';
import 'package:places_app/providers/places_provider.dart';
import 'package:places_app/screens/add_place_screen.dart';
import 'package:places_app/screens/loading_screen.dart';
import 'package:places_app/screens/place_detail_screen.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> dataLoader;

  @override
  void initState() {
    super.initState();
    final placesNotifier = ref.read(placesProvider.notifier);
    dataLoader = placesNotifier.loadPlaces();
  }

  Widget _placeListTile(BuildContext context, Place place) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading:
            CircleAvatar(backgroundImage: FileImage(place.image), radius: 25),
        title: Text(
          place.title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        subtitle: Text(
          place.location.address,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(place: place),
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(placesProvider);
    Widget content;

    if (placesList.isEmpty) {
      content = const Center(
        child: Text(
          'No places added yet',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: placesList.length,
        itemBuilder: (context, index) =>
            _placeListTile(context, placesList[index]),
      );
    }

    Widget screenIfPlacesLoaded = Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddPlaceScreen(),
              ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
        child: content,
      ),
    );

    return FutureBuilder(
      future: dataLoader,
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const LoadingScreen()
            : screenIfPlacesLoaded;
      },
    );
  }
}
