import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFB2DFDB), // light teal background
        child: Column(
          children: [
            // My Profile Button
            ListTile(
              leading: const Icon(Icons.person, size: 30),
              title: const Text('My Profile', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            // Scan Report Button
            ListTile(
              leading: const Icon(Icons.scanner, size: 30),
              title: const Text('Scan Report', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pushNamed(context, '/upload'); // Updated route
              },
            ),
            // Analytics Button
            ListTile(
              leading: const Icon(Icons.analytics, size: 30),
              title: const Text('Analytics', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pushNamed(context, '/analytics'); // Updated route
              },
            ),
            // History Button
            ListTile(
              leading: const Icon(Icons.history, size: 30),
              title: const Text('History', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            const Spacer(),
            // Log Out Button
            ListTile(
              title: const Text('Log Out', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
