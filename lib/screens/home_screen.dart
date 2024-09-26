import 'package:flutter/material.dart';
import 'upload_screen.dart';
import 'custom_drawer.dart'; // Import the custom drawer

class HomeScreen extends StatelessWidget {
  final String firstName; // Add this to accept the first name

  const HomeScreen({super.key, required this.firstName}); // Required parameter for first name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer when the menu button is pressed
              },
            );
          },
        ),
        title: Row(
          children: [
            const Text(
              'Hello, ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              firstName, // Dynamically display the user's first name
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(), // Add the custom drawer here
      body: Stack(
        children: [
          // Background image with low opacity
          Opacity(
            opacity: 0.3, // Adjust the opacity as needed
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/laptop_test.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Get started with testing',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: _buildCameraButton(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadScreen()),
        );
      },
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          color: const Color(0xFF4B3A71), // Keep the color consistent
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 50.0, color: Colors.white),
            SizedBox(height: 10.0),
            Text(
              'Scan',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
