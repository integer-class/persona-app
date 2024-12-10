import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import 'dart:io';
import '../../data/models/prediction_model.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Accessory? selectedHairstyle;
  Accessory? selectedGlasses;
  Accessory? selectedEarrings;

  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final args = state.extra as Map<String, dynamic>?;

    // Jika ada selectedItem, tambahkan ke recommendation yang sesuai
    if (args?['selectedItem'] != null) {
      final selectedItem = args!['selectedItem'] as Accessory;
      final prediction = args['prediction'] as Prediction;

      // Update selected items when returning from recommendation screens
      if (args?['selectedItem'] != null) {
        final selectedItem = args!['selectedItem'] as Accessory;

        if (selectedItem.category == Category.GLASSES) {
          selectedGlasses = selectedItem;
        } else if (selectedItem.category == Category.EARRINGS) {
          selectedEarrings = selectedItem;
        } else {
          selectedHairstyle = selectedItem;
        }
      }
    }

    // Preserve existing selections when navigating
    if (args?['keepSelections'] != null) {
      final Map<String, Accessory> selections = args!['keepSelections'];
      selectedHairstyle = selections['hairstyle'] ?? selectedHairstyle;
      selectedGlasses = selections['glasses'] ?? selectedGlasses;
      selectedEarrings = selections['earrings'] ?? selectedEarrings;
    }

    final String gender = args?['gender'] ?? 'Unknown';
    final Prediction? prediction = args?['prediction'];
    final File? imageFile = args?['imageFile'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Ubah warna ikon menjadi putih
          onPressed: () {
            context.go(RouteConstants
                .uploadRoute); // Responsif kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'Edit',
          style:
              TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
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
                    prediction?.data.faceShape != null &&
                            prediction!.data.faceShape.isNotEmpty
                        ? 'Our system detects your face is "${prediction.data.faceShape}"'
                        : 'Unable to detect face shape',
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
                child: imageFile != null
                    ? Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/jessica.png',
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
                  selectedImageUrl: selectedHairstyle?.image,
                  onTap: () {
                    context.go(RouteConstants.hairstyleRoute, extra: {
                      'recommendations':
                          prediction?.data.recommendations.hairStyles,
                      'otherOptions': prediction?.data.otherOptions.hairStyles,
                      'title': 'Hair Style',
                      'gender': gender,
                      'prediction': prediction,
                      'imageFile': imageFile,
                      'selectedItem': selectedHairstyle,
                      'keepSelections': {
                        'hairstyle': selectedHairstyle,
                        'glasses': selectedGlasses,
                        'earrings': selectedEarrings,
                      },
                    });
                  },
                ),
                // Glasses Button
// Glasses button
                NavigationButton(
                  imagePath: 'assets/images/glasses.png',
                  label: 'Glasses',
                  selectedImageUrl: selectedGlasses?.image, // Tambahkan ini
                  onTap: () {
                    final glassesRecommendations = prediction
                        ?.data.recommendations.accessories
                        .where((a) => a.category == Category.GLASSES)
                        .toList();
                    final glassesOtherOptions = prediction
                        ?.data.otherOptions.accessories
                        .where((a) => a.category == Category.GLASSES)
                        .toList();

                    context.go(RouteConstants.glassesRoute, extra: {
                      'recommendations': glassesRecommendations,
                      'otherOptions': glassesOtherOptions,
                      'title': 'Glasses',
                      'gender': gender,
                      'prediction': prediction,
                      'imageFile': imageFile,
                      'selectedItem': selectedGlasses,
                      'keepSelections': {
                        'hairstyle': selectedHairstyle,
                        'glasses': selectedGlasses,
                        'earrings': selectedEarrings,
                      },
                    });
                  },
                ),
                // Accessory Button (only if gender is Female)
                if (gender == 'Female')
                  NavigationButton(
                    imagePath: 'assets/images/accessorry.png',
                    label: 'Earrings',
                    selectedImageUrl: selectedEarrings?.image, // Tambahkan ini
                    onTap: () {
                      final earringsRecommendations = prediction
                          ?.data.recommendations.accessories
                          .where((a) => a.category == Category.EARRINGS)
                          .toList();
                      final earringsOtherOptions = prediction
                          ?.data.otherOptions.accessories
                          .where((a) => a.category == Category.EARRINGS)
                          .toList();

                      context.go(RouteConstants.accessoriesRoute, extra: {
                        'recommendations': earringsRecommendations,
                        'otherOptions': earringsOtherOptions,
                        'title': 'Earrings Recommendations',
                        'gender': gender,
                        'prediction': prediction,
                        'imageFile': imageFile,
                        'selectedItem': selectedEarrings,
                        'keepSelections': {
                          'hairstyle': selectedHairstyle,
                          'glasses': selectedGlasses,
                          'earrings': selectedEarrings,
                        },
                      });
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
  final String? selectedImageUrl;

  const NavigationButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.selectedImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          selectedImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    selectedImageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
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
