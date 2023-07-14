import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places_app/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  Future<File> _saveImageFileLocally(File image) async {
    final appDocDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedFile = await image.copy(path.join(appDocDir.path, fileName));
    return savedFile;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE added_places (id TEXT PRIMARY KEY, title TEXT, imagePath TEXT, lat REAL, lng REAL, address TEXT)');
      },
    );
  }

  Future<void> loadPlaces() async {
    final db = await _openDatabase();
    final listOfRows = await db.query('added_places');
    final places = listOfRows
        .map((row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['imagePath'] as String),
              location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String,
              ),
            ))
        .toList();

    state = places;
  }

  void addPlace(Place place) async {
    final savedImage = await _saveImageFileLocally(place.image);
    final newPlace = place.copyWith(image: savedImage);

    final db = await _openDatabase();

    db.insert('added_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'imagePath': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [...state, newPlace];
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
