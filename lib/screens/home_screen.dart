import 'package:flutter/material.dart';
import 'upload_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: const Row(
          children: [
            Text(
              'Hello, ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'User', // This should be dynamically updated
              style: TextStyle(
                color: Colors.teal,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
       
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF6EC8C0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/laptop_test.png',
                height: 150.0, // Adjusted height to fit on screen
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFE6EEFF),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Get start with testing',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTestOption(context, 'MRI', Icons.scanner, const Color(0xFF2A4163)),
                      _buildTestOption(context, 'CT Scan', Icons.medical_services, const Color(0xFF178682)),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: _buildTestOption(context, 'Lab Reports', Icons.description, const Color(0xFF4B3A71)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.teal,
        onTap: (index) {
          // Handle navigation here
        },
      ),
    );
  }

  Widget _buildTestOption(BuildContext context, String title, IconData icon, Color color) {
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
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50.0, color: Colors.white),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: const TextStyle(
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
