// ignore_for_file: public_member_api_doc, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageWidget extends StatefulWidget {
  final void Function(File image) onSelectImage;
  const ImageWidget({
    Key? key,
    required this.onSelectImage,
  }) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  File? _selectedImage;

  void _takePicture(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxHeight: 600,
    );
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget buttons = Center(
      child: Container(
        color: Colors.black54,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                _takePicture(ImageSource.gallery);
              },
              icon: const Icon(Icons.collections),
              label: const Text(
                'Use Album',
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _takePicture(ImageSource.camera);
              },
              icon: const Icon(Icons.add_a_photo),
              label: const Text(
                'Use Camera',
              ),
            ),
          ],
        ),
      ),
    );

    Widget content = buttons;

    if (_selectedImage != null) {
      content = Stack(children: [
        Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        buttons,
      ]);
    }

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1, color: Theme.of(context).colorScheme.onBackground),
      ),
      child: content,
    );
  }
}
