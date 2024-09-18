import 'package:flutter/material.dart';
import 'dart:io'; // To handle the File object
import 'analytics_screen.dart';

class ResultScreen extends StatelessWidget {
  final bool success;
  final List<dynamic>? ocrResult;
  final File imageFile; // Add a File parameter to display the image

  const ResultScreen({
    super.key,
    required this.success,
    this.ocrResult,
    required this.imageFile, // Receive the imageFile here
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Report'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Action for the menu button, can be added later
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the scanned image
            Expanded(
              child: success
                  ? Image.file(
                      imageFile, // Display the submitted image
                      fit: BoxFit.contain,
                    )
                  : const Text('Failed to display image.'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Scan Another Report button
                ElevatedButton(
                  onPressed: () {
                    // Logic to open the camera or gallery for scanning another report
                    Navigator.pop(context); // This goes back to the previous screen
                  },
                  child: const Text('Scan Another Report'),
                ),
                const SizedBox(width: 16),
                // View Analytics button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AnalyticsScreen(imageFile: imageFile),
                      ),
                    );
                  },
                  child: const Text('View Analytics'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
