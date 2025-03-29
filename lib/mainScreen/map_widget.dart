import 'package:digital_time_capsule/location_service.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    final locationData = await _locationService.getCurrentLocation(context);
    if (locationData != null && mounted) {
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      // Move the map to the user's location after a short delay for smooth transition
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && _currentLocation != null) {
          _mapController.move(_currentLocation!, 14.0);
        }
      });
    }
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
            initialCenter: _currentLocation ?? const LatLng(35.8992, 14.5141),
            initialZoom: 13.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              pinchZoomThreshold: 1.5,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              tileSize: 256,
              maxZoom: 18,
              minZoom: 3,
            ),
          ],
        ),
      ),
    );
  }
}
