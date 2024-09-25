import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  final String userId; // Add userId parameter

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String dateOfBirth = '';
  String phone = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the screen initializes
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/user/${widget.userId}'), // Update to your endpoint
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = '${data['first_name']} ${data['last_name']}';
          email = data['email'];
          dateOfBirth = data['date_of_birth'];
          phone = data['phone'] ?? ''; // Handle cases where phone might not exist
          isLoading = false; // Set loading to false when data is fetched
        });
      } else {
        // Handle errors
        final errorResponse = jsonDecode(response.body);
        _showErrorDialog(errorResponse['message'] ?? "Error fetching user data");
      }
    } catch (e) {
      // Handle connection errors
      _showErrorDialog("Failed to connect to the server");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const CustomDrawer(), // Hamburger menu (drawer)
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loading indicator
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile_picture.png'), // Profile picture
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Name: $name',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Date of Birth: $dateOfBirth',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Phone: $phone',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action to edit profile
                      },
                      child: const Text('Edit Profile', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
