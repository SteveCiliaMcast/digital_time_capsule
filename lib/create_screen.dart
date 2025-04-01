// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'createScreen/capsule_form.dart';
import 'bottom_nav_bar.dart';
import 'createScreen/photo_capture_widget.dart'; // Import the new widget
import '../main.dart'; // Import the initialized notification plugin
import 'services/location_service.dart'; // Import the LocationService

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('capsules');
  final LocationService _locationService =
      LocationService(); // Use LocationService
  String? _base64Image;

  void _getCurrentLocation() async {
    final position = await _locationService.getCurrentLocation(context);
    if (position != null) {
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String description = _descriptionController.text;
      double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
      double longitude = double.tryParse(_longitudeController.text) ?? 0.0;

      Map<String, dynamic> capsule = {
        'title': title,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'image': _base64Image, // Save the Base64 image
        'created_at': DateTime.now().toIso8601String(),
      };

      try {
        await _dbRef.push().set(capsule);

        // Show success notification
        _showNotification();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Capsule Created Successfully!')),
        );
        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving capsule: $e')),
        );
      }
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'capsule_channel', // Channel ID
      'Capsule Notifications', // Channel name
      channelDescription: 'Notifications for capsule creation',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Capsule Created', // Notification title
      'A new capsule has been successfully created!', // Notification body
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Capsule"),
        automaticallyImplyLeading: false, // Removes back button
      ),
      resizeToAvoidBottomInset:
          true, // Ensures keyboard does not cause overflow
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Photo Capture Widget
                PhotoCaptureWidget(
                  onImageCaptured: (base64) {
                    setState(() {
                      _base64Image = base64;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Capsule Form Fields
                CapsuleForm(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  latitudeController: _latitudeController,
                  longitudeController: _longitudeController,
                  getCurrentLocation: _getCurrentLocation,
                  submitForm: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Create index
        context: context,
      ),
    );
  }
}
