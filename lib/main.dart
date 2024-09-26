import 'package:flutter/material.dart';
import 'screens/lets_go_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/result_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/history_screen.dart'; // Import for the history screen
import 'screens/profile_screen.dart'; // Import for the profile screen
import 'screens/camera.dart'; // Import for the camera screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediScanApp());
}

class MediScanApp extends StatelessWidget {
  const MediScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medi Scan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LetsGoScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return HomeScreen(firstName: args['firstName']); // Pass first name to HomeScreen
        },
        '/upload': (context) => const UploadScreen(),
        // ResultScreen route with arguments
        '/result': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ResultScreen(
            success: args['success'],
            ocrResult: args['ocrResult'],
            imageFile: args['imageFile'],
          );
        },
        // AnalyticsScreen route with arguments
        '/analytics': (context) => const AnalyticsScreen(),
        // Add new routes for the Profile and History screens
        '/profile': (context) => const ProfileScreen(), // Profile screen route
        '/history': (context) => const HistoryScreen(), // History screen route
        '/camera': (context) => const CameraPage(), // Added route for the camera screen
      },
    );
  }
}
