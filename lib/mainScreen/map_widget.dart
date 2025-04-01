// import 'dart:convert';
// import 'package:digital_time_capsule/location_service.dart';
// import 'package:digital_time_capsule/capsule_marker.dart';
import 'package:digital_time_capsule/mainScreen/capsule_marker.dart';
import 'package:digital_time_capsule/services/location_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  final DatabaseReference _capsulesRef =
      FirebaseDatabase.instance.ref('capsules');
  List<Map<String, dynamic>> _capsules = [];

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    _fetchCapsules();
  }

  Future<void> _fetchUserLocation() async {
    final locationData = await _locationService.getCurrentLocation(context);
    if (locationData != null && mounted) {
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude, locationData.longitude);
      });

      Future.delayed(const Duration(milliseconds: 1), () {
        if (mounted && _currentLocation != null) {
          _mapController.move(_currentLocation!, 15.0);
        }
      });
    }
  }

  Future<void> _fetchCapsules() async {
    _capsulesRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _capsules = data.entries.map((entry) {
            final value = entry.value as Map<dynamic, dynamic>;
            return {
              "title": value["title"] ?? "Untitled",
              "latitude": value["latitude"] ?? 0.0,
              "longitude": value["longitude"] ?? 0.0,
              "description": value["description"] ?? "",
              "image": value["image"] ?? "", // Base64 image
            };
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 400,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter:
                _currentLocation ?? const LatLng(35.8992375, 14.5140996),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),

            // Light Blue Circle for 500m Radius
            if (_currentLocation != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _currentLocation!,
                    radius: 500, // 500m radius
                    useRadiusInMeter: true,
                    // ignore: deprecated_member_use
                    color: Colors.lightBlue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),

            // Capsule Markers
            MarkerLayer(
              markers: _capsules
                  .map((capsule) =>
                      CapsuleMarker.create(capsule, context, _currentLocation))
                  .toList(),
            ),

            // Red Arrow Marker for User Location
            if (_currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation!,
                    width: 20,
                    height: 20,
                    child: Transform.rotate(
                      angle: 0, // Adjust if you want it to rotate dynamically
                      child: const Icon(
                        Icons.circle, // Arrow-like icon
                        color: Colors.red,
                        size: 10,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
