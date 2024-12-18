import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasource/local/prediction_local_datasource.dart';
import '../../data/datasource/remote/prediction_remote_datasource.dart';
import '../../data/models/user_choice_model.dart';
import '../../router/app_router.dart';
import 'dart:io';
import '../../data/models/prediction_model.dart';
import '../../provider/selection_provider.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/prediction_repository.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final PredictionRepository _predictionRepository = PredictionRepository(
    PredictionLocalDataSource(),
    PredictionRemoteDataSource(),
  );

  @override
  Widget build(BuildContext context) {
    final selectionProvider = Provider.of<SelectionProvider>(context);
    final GoRouterState state = GoRouterState.of(context);
    final args = state.extra as Map<String, dynamic>?;

    if (args?['selectedItem'] != null) {
      final selectedItem = args!['selectedItem'] as Accessory;
      if (selectedItem.category == Category.GLASSES) {
        selectionProvider.updateSelection('glasses', selectedItem);
      } else if (selectedItem.category == Category.EARRINGS) {
        selectionProvider.updateSelection('earrings', selectedItem);
      } else {
        selectionProvider.updateSelection('hairstyle', selectedItem);
      }
    }

    final String gender = args?['gender'] ?? 'Unknown';
    final Prediction? prediction = args?['prediction'];
    final File? imageFile = args?['imageFile'];

    Future<void> _deleteImage() async {
      if (imageFile != null) {
        try {
          await _predictionRepository
              .deleteImage(prediction!.data.predictionId);
        } catch (e) {
          print('Error deleting image: $e');
        }
      }
    }

    void _showLoginDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Authentication Required'),
          content: Text('You need to log in to save your selection.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(RouteConstants.loginRoute, extra: {
                  'userSelection': UserSelection(
                    predictionId: prediction!.data.predictionId,
                    recommendationId: prediction.data.recommendationsId.first,
                    selectedHairStyleId:
                        selectionProvider.selectedHairstyle?.id ?? 0,
                    selectedAccessoriesIds: [
                      if (selectionProvider.selectedGlasses != null)
                        selectionProvider.selectedGlasses!.id,
                      if (selectionProvider.selectedEarrings != null)
                        selectionProvider.selectedEarrings!.id,
                    ],
                  ),
                });
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteImage();
                context.go(RouteConstants.uploadRoute);
              },
              child: Text('Maybe Later'),
            ),
          ],
        ),
      );
    }

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Oops!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => context.go(RouteConstants.uploadRoute),
              child: Text('Back to Home'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Continue'),
            )
          ],
        ),
      );
    }

    bool _hasSelectedAnyRecommendation(SelectionProvider provider) {
      return provider.selectedHairstyle != null ||
          provider.selectedGlasses != null ||
          provider.selectedEarrings != null;
    }

    void _showNoSelectionDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Selection Made'),
          content:
              Text('Please select at least one recommendation before saving.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    Future<void> _saveUserSelection() async {
      final selectionProvider =
          Provider.of<SelectionProvider>(context, listen: false);
      final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final Prediction? prediction = args?['prediction'];
      if (!_hasSelectedAnyRecommendation(selectionProvider)) {
        _showNoSelectionDialog();
        return;
      }

      if (prediction != null) {
        final userSelection = UserSelection(
          predictionId: prediction.data.predictionId,
          recommendationId: prediction.data.recommendationsId.first,
          selectedHairStyleId: selectionProvider.selectedHairstyle?.id ?? 0,
          selectedAccessoriesIds: [
            if (selectionProvider.selectedGlasses != null)
              selectionProvider.selectedGlasses!.id,
            if (selectionProvider.selectedEarrings != null)
              selectionProvider.selectedEarrings!.id,
          ],
        );

        try {
          await _predictionRepository.saveUserSelection(userSelection);
          context.go(RouteConstants.uploadRoute, extra: {'showSuccess': true});
        } catch (e) {
          print('Error saving user selection: $e');
          _showErrorDialog(
              'Without logging in, you cannot save your selection.');
          _showLoginDialog();
        }
      } else {
        _showLoginDialog();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        await _deleteImage();
        context.go(RouteConstants.uploadRoute);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              await _deleteImage();
              context.go(RouteConstants.uploadRoute);
            },
          ),
          title: Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _hasSelectedAnyRecommendation(selectionProvider)
                  ? _saveUserSelection
                  : null, // Disable button when no selection
              child: Text(
                'Save',
                style: TextStyle(
                  color: _hasSelectedAnyRecommendation(selectionProvider)
                      ? Colors.white
                      : Colors.grey, // Grey out text when disabled
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Face analysis popup
                if (prediction != null) _buildFaceAnalysisPopup(prediction),
                // image section
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
                        selectedImageUrl:
                            selectionProvider.selectedHairstyle?.image,
                        onTap: () {
                          context.go(RouteConstants.hairstyleRoute, extra: {
                            'recommendations':
                                prediction?.data.recommendations.hairStyles,
                            'otherOptions':
                                prediction?.data.otherOptions.hairStyles,
                            'title': 'Hair Style',
                            'gender': gender,
                            'prediction': prediction,
                            'imageFile': imageFile,
                            'selectedItem': selectionProvider.selectedHairstyle,
                          });
                        },
                      ),
                      // Glasses Button
                      NavigationButton(
                        imagePath: 'assets/images/glasses.png',
                        label: 'Glasses',
                        selectedImageUrl:
                            selectionProvider.selectedGlasses?.image,
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
                            'selectedItem': selectionProvider.selectedGlasses,
                          });
                        },
                      ),
                      // Accessory Button (only if gender is Female)
                      if (gender == 'Female')
                        NavigationButton(
                          imagePath: 'assets/images/accessorry.png',
                          label: 'Earrings',
                          selectedImageUrl:
                              selectionProvider.selectedEarrings?.image,
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
                              'selectedItem':
                                  selectionProvider.selectedEarrings,
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Add this method to the _EditScreenState class
Widget _buildFaceAnalysisPopup(Prediction? prediction) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 224, 146, 146)?.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.face, color: Colors.white70),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                prediction?.data.faceShape != null &&
                        prediction!.data.faceShape.isNotEmpty
                    ? 'Face Shape: ${prediction.data.faceShape}'
                    : 'Face shape not detected',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
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
