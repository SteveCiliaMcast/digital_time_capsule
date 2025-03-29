// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoCaptureWidget extends StatefulWidget {
  final Function(String?) onImageCaptured; // Callback to pass Base64 image

  const PhotoCaptureWidget({super.key, required this.onImageCaptured});

  @override
  _PhotoCaptureWidgetState createState() => _PhotoCaptureWidgetState();
}

class _PhotoCaptureWidgetState extends State<PhotoCaptureWidget> {
  File? _image;
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  // Request Camera Permission
  Future<bool> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  // Take Photo and Convert to Base64
  Future<void> _takePhoto() async {
    bool hasPermission = await _requestCameraPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64String = base64Encode(imageBytes);

      setState(() {
        _image = imageFile;
        _base64Image = base64String;
      });

      // Pass Base64 to Parent Widget (CreateScreen)
      widget.onImageCaptured(_base64Image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _takePhoto,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.camera_alt, size: 50, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _takePhoto,
          child: const Text("Take Photo"),
        ),
      ],
    );
  }
}
