import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';

class EditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final args = state.extra as Map<String, dynamic>?;
    final String gender = args?['gender'] ?? 'Unknown';


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Ubah warna ikon menjadi putih
          onPressed: () {
            context.pop(); // Responsif kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'Edit',
          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        centerTitle: true,
        actions: [
          // Ganti tombol Save menjadi teks biasa
          TextButton(
            onPressed: () {
              // Navigasi ke halaman Feedback setelah Save diklik
              context.go(RouteConstants.feedbackRoute);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white, // Ubah teks menjadi putih
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Face Analysis Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Face Analysis",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Our system detects your face is "Oval".', // Replace with dynamic data
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Image Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/jessica.png', // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hair Style Button
                NavigationButton(
                  imagePath: 'assets/images/hairstyle.png',
                  label: 'Hair Styles',
                  onTap: () {
                    context.go(RouteConstants.hairstyleRoute);
                  },
                ),
                // Glasses Button
                NavigationButton(
                  imagePath: 'assets/images/glasses.png',
                  label: 'Glasses',
                  onTap: () {
                    context.go(RouteConstants.glassesRoute);
                  },
                ),
                // Accessory Button (only if gender is Female)
                if (gender == 'Female')
                  NavigationButton(
                    imagePath: 'assets/images/accessorry.png',
                    label: 'Accessory',
                    onTap: () {
                      context.go(RouteConstants.accessoriesRoute);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const NavigationButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}