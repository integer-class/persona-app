import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 94 / 139, // Maintain the aspect ratio of 94x139
          ),
          itemCount: 6, // Total number of items
          itemBuilder: (context, index) {
            // Image paths and dates
            final images = [
              'assets/images/card1.png',
              'assets/images/card2.png',
              'assets/images/card3.png',
              'assets/images/card4.png',
              'assets/images/card5.png',
              'assets/images/card6.png',
            ];
            final dates = [
              '11 - 10 - 2024',
              '16 - 11 - 2024',
              '17 - 11 - 2024',
              '11 - 10 - 2024',
              '16 - 11 - 2024',
              '17 - 11 - 2024',
            ];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image Container with fixed dimensions
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 94,
                    height: 139,
                    color: Colors.black12, // Fallback background color
                    child: Image.asset(
                      images[index],
                      width: 94,
                      height: 139,
                      fit: BoxFit.cover, // Ensures the image fits within dimensions
                      errorBuilder: (context, error, stackTrace) {
                        // Placeholder if image fails to load
                        return Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Date Text
                Text(
                  dates[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
      backgroundColor: Colors.black87, // Background color
    );
  }
}
