import 'package:digital_time_capsule/mainScreen/capsule_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:digital_time_capsule/services/location_service.dart';
import 'package:digital_time_capsule/services/capsule_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  final CapsuleService _capsuleService = CapsuleService();
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

      Future.delayed(const Duration(milliseconds: 1), () {
        if (mounted && _currentLocation != null) {
          _mapController.move(_currentLocation!, 13.0);
        }
      });
    }
  }

  void _fetchCapsules() {
    _capsuleService.getCapsulesStream().listen((capsules) {
      if (mounted) {
        setState(() {
          _capsules = capsules;
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
            initialCenter: _currentLocation ?? const LatLng(1, 1),
            initialZoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _capsules
                  .map((capsule) => CapsuleMarker.create(capsule, context))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
