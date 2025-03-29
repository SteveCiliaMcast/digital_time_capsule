// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'bottom_nav_bar.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('capsules');

  List<Map<String, dynamic>> _capsules = [];

  @override
  void initState() {
    super.initState();
    _fetchCapsules();
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
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(capsule['title'] ?? "No Title"),
                    subtitle: Text(capsule['description'] ?? "No Description"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Lat: ${capsule['latitude']}"),
                        Text("Lng: ${capsule['longitude']}"),
                      ],
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
