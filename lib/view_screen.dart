// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'bottom_nav_bar.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('capsules');
  final Location _location = Location();

  List<Map<String, dynamic>> _capsules = [];
  double? _userLatitude;
  double? _userLongitude;

  @override
  void initState() {
    super.initState();
    _fetchCapsules();
    _getCurrentLocation();
  }

  void _fetchCapsules() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _capsules = data.entries.map((entry) {
            final capsule = Map<String, dynamic>.from(entry.value);
            capsule['id'] = entry.key; // Save ID for future actions
            return capsule;
          }).toList();
        });
      }
    });
  }

  void _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _userLatitude = locationData.latitude;
        _userLongitude = locationData.longitude;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371000; // Earth radius in meters
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLng = _degreesToRadians(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _deleteCapsule(String id) async {
    try {
      await _dbRef.child(id).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Capsule deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete capsule: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Capsules"),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: _capsules.isEmpty
          ? const Center(child: Text("No capsules found."))
          : ListView.builder(
              itemCount: _capsules.length,
              itemBuilder: (context, index) {
                final capsule = _capsules[index];
                final distance =
                    (_userLatitude != null && _userLongitude != null)
                        ? _calculateDistance(
                            _userLatitude!,
                            _userLongitude!,
                            capsule['latitude'] ?? 0.0,
                            capsule['longitude'] ?? 0.0,
                          )
                        : null;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(capsule['title'] ?? "No Title"),
                    subtitle: distance != null
                        ? Text(
                            "Distance: ${(distance / 1000).toStringAsFixed(2)} km")
                        : const Text("Distance: Unknown"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCapsule(capsule['id']),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // View index
        context: context,
      ),
    );
  }
}
