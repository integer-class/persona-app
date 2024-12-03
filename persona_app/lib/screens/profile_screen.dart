import 'package:flutter/material.dart';
import 'history_screen.dart'; // Import the History Screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Information Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          const AssetImage('assets/images/profile.png'),
                    ),
                    const SizedBox(width: 16),
                    // Name and Email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Jessica Tjiu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'jesstjiu10@gmail.com',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // History Section
              ListTile(
                leading: const Icon(Icons.history, size: 30, color: Colors.black87),
                title: const Text(
                  'History',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              // Settings Section
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, size: 30, color: Colors.black87),
                title: const Text(
                  'Notification',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  // Add Notification navigation or functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, size: 30, color: Colors.black87),
                title: const Text(
                  'Information',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  // Add Information navigation or functionality here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
