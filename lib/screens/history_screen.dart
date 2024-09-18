import 'package:flutter/material.dart';
import 'custom_drawer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHistoryItem(context, '12 September 2024', 'Blood Test Report', 'View Details'),
            const Divider(),
            _buildHistoryItem(context, '15 August 2024', 'Lipid Profile Test', 'View Details'),
            const Divider(),
            _buildHistoryItem(context, '20 July 2024', 'Complete Blood Count (CBC)', 'View Details'),
            const Divider(),
            // Add more history items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, String date, String reportType, String actionText) {
    return ListTile(
      leading: const Icon(Icons.description, size: 30),
      title: Text(reportType, style: const TextStyle(fontSize: 18)),
      subtitle: Text('Date: $date'),
      trailing: TextButton(
        onPressed: () {
          // Action to view report details
        },
        child: Text(actionText, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
