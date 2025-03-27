// location_service.dart
// ignore_for_file: use_build_context_synchronously

import 'package:location/location.dart';
import 'package:flutter/material.dart';

class LocationService {
  final Location _location = Location();

  // Function to get current location
  Future<LocationData?> getCurrentLocation(BuildContext context) async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location service is disabled')),
          );
          return null;
        }
      }

      // Check for permission
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return null;
        }
      }

      // Get current location
      return await _location.getLocation();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
      return null;
    }
  }
}
