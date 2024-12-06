import 'package:flutter/material.dart';
import 'package:persona_app/screens/feedbackscreen.dart';
import 'accessories_screen.dart';
import 'glasses_screen.dart';
import 'hairstyle_screen.dart';

class EditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String gender = args?['gender'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Ubah warna ikon menjadi putih
          onPressed: () {
            Navigator.pop(context); // Responsif kembali ke halaman sebelumnya
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackScreen(),
                ),
              );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => hairstylescreen()),
                    );
                  },
                ),
                // Glasses Button
                NavigationButton(
                  imagePath: 'assets/images/glasses.png',
                  label: 'Glasses',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => glassesscreen()),
                    );
                  },
                ),
                // Accessory Button (only if gender is Female)
                if (gender == 'Female')
                  NavigationButton(
                    imagePath: 'assets/images/accessorry.png',
                    label: 'Accessory',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => accessoriesscreen()),
                      );
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
