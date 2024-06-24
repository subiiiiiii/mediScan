import 'package:flutter/material.dart';
import 'screens/lets_go_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(MediScanApp());
}

class MediScanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medi Scan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LetsGoScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/upload': (context) => UploadScreen(),
        '/result': (context) => ResultScreen(),
      },
    );
  }
}
