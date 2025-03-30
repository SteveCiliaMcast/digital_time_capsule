import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'capsule_details.dart';

class CapsuleMarker {
  static Marker create(Map<String, dynamic> capsule, BuildContext context) {
    return Marker(
      width: 120.0,
      height: 50.0,
      point: LatLng(capsule["latitude"], capsule["longitude"]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 3)
              ],
            ),
            child: Text(
              capsule["title"],
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => showCapsuleDetails(context, capsule),
            child: const Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 127, 4, 135),
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
