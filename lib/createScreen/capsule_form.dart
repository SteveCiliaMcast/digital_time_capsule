import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // For the location icon

class CapsuleForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final VoidCallback getCurrentLocation;
  final VoidCallback submitForm;

  const CapsuleForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.latitudeController,
    required this.longitudeController,
    required this.getCurrentLocation,
    required this.submitForm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Moves form lower
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(titleController, 'Title'),
        const SizedBox(height: 16),
        _buildTextField(descriptionController, 'Description'),
        const SizedBox(height: 16),

        // Latitude & Longitude Row
        Row(
          children: [
            Expanded(
                child: _buildTextField(latitudeController, 'Latitude',
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(LucideIcons.locateFixed), // Location icon
              onPressed: getCurrentLocation,
              tooltip: 'Get Current Location',
            ), // Space between fields
            Expanded(
                child: _buildTextField(longitudeController, 'Longitude',
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 8),
            // Location Button
          ],
        ),
        const SizedBox(height: 24),

        // Submit Button
        ElevatedButton(
          onPressed: submitForm,
          child: const Text('Create Capsule'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
