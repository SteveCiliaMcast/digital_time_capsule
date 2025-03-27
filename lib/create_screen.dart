import 'package:flutter/material.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Screen")),
      body: const Center(
        child: Text("Create Screen", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
