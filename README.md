# Native Features App

This Flutter app allows users to capture photos of their favorite places, add locations either by using their current location or by selecting on a map, and store this information in local storage using the `sqflite` package. This app is a great way to keep track of memorable places and store them for future reference.

## Features

- **Capture Photos:** Users can take pictures of their favorite places directly within the app.
- **Add Location:** Users can add the location of the place either by using their current GPS location or by manually selecting the location on a map.
- **Local Storage:** All data, including the photo and location, is stored locally on the device using the `sqflite` package, ensuring that the app works offline.
- **View Saved Places:** Users can view a list of all the places they've saved, including the photo and location details.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) should be installed on your machine.
- Compatible device or emulator to run the app.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/amanat-2003/native-app.git
   cd native-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Capture a Photo:** Click the "Add Place" button and take a picture of the location you want to save.
2. **Add Location:** Choose to add the location using your current GPS coordinates or by selecting a place on the map.
3. **Save the Place:** Once the photo and location are added, save the place to store it locally on your device.
4. **View Saved Places:** Access the list of saved places to view photos and locations at any time.

## Packages Used

- [`sqflite`](https://pub.dev/packages/sqflite): SQLite plugin for Flutter to handle local storage.
- [`image_picker`](https://pub.dev/packages/image_picker): A Flutter plugin for selecting images from the device's library or taking new pictures using the camera.
- [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter): A Flutter plugin for integrating Google Maps.
- [`location`](https://pub.dev/packages/location): A Flutter plugin to get the user's location.

## Screenshot

![screenshot](https://github.com/user-attachments/assets/55165444-a2d5-4e78-845d-4cffceee4632)

## Demo

[![Native Features App](https://img.youtube.com/vi/rsN9XGSiaEM/0.jpg)](https://youtu.be/rsN9XGSiaEM "Native Features App")

Check out the demo video [here](https://youtu.be/rsN9XGSiaEM).

## Blog

Read more about the app development process and its features in this [blog post](https://amanatsingh.tech/native-features-app).

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you find any bugs or have feature requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
