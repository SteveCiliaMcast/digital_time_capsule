import 'package:digital_time_capsule/main.dart';
import 'package:flutter/material.dart';
import 'create_screen.dart';
import 'view_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final BuildContext context;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.context,
  });

  void _onTabSelected(int index) {
    if (index == currentIndex) return; // Prevent reloading the same screen

    switch (index) {
      case 0: // Home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainApp()),
          (route) => false, // Removes all previous routes
        );
        break;
      case 1: // Create
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateScreen()),
        );
        break;
      case 2: // View
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ViewScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _onTabSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: "Create",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.visibility),
          label: "View",
        ),
      ],
      selectedItemColor: Colors.purple, // Adjust to your theme
      unselectedItemColor: Colors.grey,
    );
  }
}
