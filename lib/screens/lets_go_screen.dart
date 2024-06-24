import 'package:flutter/material.dart';

class LetsGoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(204, 222, 255, 1.0), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2), // Add spacer to shift content down
            Container(
              width: 300,
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 110.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(33, 112, 137, 0.4), // Light blue background for the logo container
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 150),
                  SizedBox(height: 32),
                  Text(
                    'mediScan, medical reports in your pocket',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20, // Font size adjusted to match the design
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(44, 58, 71, 1.0), // Text color
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 1), // Add more space below the container
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(39, 147, 147, 1.0), // Button color
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(
                'Let\'s Go',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Button text color
                ),
              ),
            ),
            Spacer(), // Add more space below the button
          ],
        ),
      ),
    );
  }
}
