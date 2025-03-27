import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'capsule_form.dart';

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
  final Location _location = Location();

  void _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      LocationData currentLocation = await _location.getLocation();
      setState(() {
        _latitudeController.text = currentLocation.latitude.toString();
        _longitudeController.text = currentLocation.longitude.toString();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print(
          'Capsule Created: ${_titleController.text}, ${_latitudeController.text}, ${_longitudeController.text}');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Capsule")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: CapsuleForm(
            titleController: _titleController,
            descriptionController: _descriptionController,
            latitudeController: _latitudeController,
            longitudeController: _longitudeController,
            getCurrentLocation: _getCurrentLocation,
            submitForm: _submitForm,
          ),
        ),
      ),
    );
  }
}
