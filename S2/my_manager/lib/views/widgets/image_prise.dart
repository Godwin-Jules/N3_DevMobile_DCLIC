import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePrise extends StatefulWidget {
  const ImagePrise({super.key, required this.onPhotoSelectionnee});

  final void Function(File image) onPhotoSelectionnee;

  @override
  State<ImagePrise> createState() => _ImagePriseState();
}

class _ImagePriseState extends State<ImagePrise> {
  File? _photoSelectionnee;

  Future<void> _prendrePhoto() async {
    final imagePicker = ImagePicker();

    final imageCapturee = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageCapturee == null) {
      return;
    }

    final imageFile = File(imageCapturee.path);

    setState(() {
      _photoSelectionnee = imageFile;
    });

    widget.onPhotoSelectionnee(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    Widget contenu = TextButton.icon(
      onPressed: _prendrePhoto,
      icon: const Icon(Icons.camera_alt),
      label: const Text('Prendre une photo'),
    );

    if (_photoSelectionnee != null) {
      contenu = GestureDetector(
        onTap: _prendrePhoto,
        child: Image.file(
          _photoSelectionnee!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: contenu,
    );
  }
}
