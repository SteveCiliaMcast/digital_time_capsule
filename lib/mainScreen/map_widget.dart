import 'package:digital_time_capsule/location_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
// import 'location_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
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
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      Future.delayed(const Duration(milliseconds: 200), () {
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
            initialCenter: _currentLocation ?? const LatLng(37.7749, -122.4194),
            initialZoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _capsules.map((capsule) {
                return Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(capsule["latitude"], capsule["longitude"]),
                  child: GestureDetector(
                    onTap: () => _showCapsuleDetails(context, capsule),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCapsuleDetails(BuildContext context, Map<String, dynamic> capsule) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(capsule["title"]),
          content: Text(capsule["description"]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
