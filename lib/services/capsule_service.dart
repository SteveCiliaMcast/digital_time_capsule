import 'package:firebase_database/firebase_database.dart';

class CapsuleService {
  final DatabaseReference _capsulesRef =
      FirebaseDatabase.instance.ref('capsules');

  Stream<List<Map<String, dynamic>>> getCapsulesStream() {
    return _capsulesRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.entries.map((entry) {
        final value = entry.value as Map<dynamic, dynamic>;
        return {
          "title": value["title"] ?? "Untitled",
          "latitude": value["latitude"] ?? 0.0,
          "longitude": value["longitude"] ?? 0.0,
          "description": value["description"] ?? "",
          "image": value["image"] ?? "",
        };
      }).toList();
    });
  }
}
