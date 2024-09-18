import 'package:flutter/material.dart';
import 'dart:io'; // To handle the File object

class AnalyticsScreen extends StatelessWidget {
  final File imageFile; // Expect the File object

  const AnalyticsScreen({
    super.key,
    required this.imageFile, // Receive the imageFile here
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Analytics for the submitted image.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.file(
              imageFile, // Display the submitted image
              fit: BoxFit.contain,
              height: 200,
            ),
            // Add analytics display here
            // For example, you could display some placeholder text or actual analytics data
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
