import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Import for distance calculation

void showCapsuleDetails(
    BuildContext context, Map<String, dynamic> capsule, LatLng? userLocation) {
  if (userLocation == null) {
    // Show warning if location isn't available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Unable to determine your location."),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  const Distance distance = Distance();
  final double capsuleDistance = distance.as(LengthUnit.Meter, userLocation,
      LatLng(capsule["latitude"], capsule["longitude"]));

  if (capsuleDistance > 500) {
    // Show warning if capsule is too far
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "You need to be within 500m to open this capsule. (You are ${capsuleDistance.toStringAsFixed(1)}m away)"),
        duration: const Duration(seconds: 2),
      ),
    );
    return;
  }

  // Show details dialog if within 500m
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                capsule["title"],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                capsule["description"],
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              if (capsule["image"].isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    base64Decode(capsule["image"]),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE3B6B1),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
