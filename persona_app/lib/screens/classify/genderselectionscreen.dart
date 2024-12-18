import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasource/local/prediction_local_datasource.dart';
import '../../data/datasource/remote/prediction_remote_datasource.dart';
import '../../data/models/prediction_model.dart';
import '../../data/repositories/prediction_repository.dart';
import '../../router/app_router.dart';
import '../utils/prediction_loading_overlay.dart';

class GenderSelectionScreen extends StatefulWidget {
  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  Prediction? prediction; // Untuk menyimpan hasil prediksi
  String selectedGender = ''; // Untuk menyimpan gender yang dipilih
  dynamic selectedFile; // Simpan file yang diterima melalui arguments
  bool isLoading = false;
  String _loadingState = '';
  double _loadingProgress = 0.0;
  final PredictionRepository _predictionRepository = PredictionRepository(
    PredictionLocalDataSource(),
    PredictionRemoteDataSource(),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // engambil file dari arguments jika ada
    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (args != null && args['file'] != null) {
      selectedFile = args['file'];
      print("Received File: ${selectedFile.path}");
    } else {
      print('No file received in arguments.');
    }
  }

  void _showErrorDialog(String title, String message, {VoidCallback? onRetry}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title,
            style:
                TextStyle(color: Colors.red[300], fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            SizedBox(height: 16),
            Text(
              'Suggestions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Make sure the face is clearly visible'),
            Text('• Ensure good lighting conditions'),
            Text('• Try using a different photo'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .go(RouteConstants.uploadRoute); // Go back to upload screen
            },
            child: Text('Choose Another Photo'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              child: Text('Retry'),
            ),
        ],
      ),
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('500')) {
      return 'We could not process your image properly. This could be because:\n\n'
          '• The face in the image is not clear enough\n'
          '• The lighting conditions are not optimal\n'
          '• The image quality is too low';
    } else if (error.toString().contains('timeout')) {
      return 'The connection timed out. Please check your internet connection and try again.';
    } else {
      return 'An unexpected error occurred. Please try again or use a different photo.';
    }
  }

  Future<void> _handleContinue() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      _loadingState = 'Preparing image';
      _loadingProgress = 0.2;
    });

    try {
      print('Starting prediction...');
      print('Image path: ${selectedFile.path}');
      print('Selected gender: $selectedGender');

      setState(() {
        _loadingState = 'Analyzing';
        _loadingProgress = 0.4;
      });

      await Future.delayed(Duration(milliseconds: 500)); // Smooth transition

      final prediction = await _predictionRepository.predict(
        selectedFile.path,
        selectedGender.toLowerCase(),
      );

      setState(() {
        _loadingState = 'Generating';
        _loadingProgress = 0.8;
      });

      await Future.delayed(Duration(milliseconds: 500)); // Smooth transition

      if (!mounted) return;

      if (prediction.data.faceShape.isEmpty) {
        throw Exception('Could not detect face shape in image');
      }

      print('Prediction successful: ${prediction.data.faceShape}');

      setState(() {
        _loadingState = 'Complete!';
        _loadingProgress = 1.0;
      });

      await Future.delayed(Duration(milliseconds: 300));

      context.go(
        RouteConstants.editRoute,
        extra: {
          'gender': selectedGender,
          'prediction': prediction,
          'imageFile': selectedFile,
        },
      );
    } catch (e) {
      if (!mounted) return;

      _showErrorDialog(
        'Image Processing Failed',
        _getErrorMessage(e),
        onRetry: _handleContinue,
      );

      // Also show a snackbar for immediate feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                    'Failed to analyze image. Please check the error details.'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'DISMISS',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouteConstants.uploadRoute);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose Gender',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGender = 'Male';
                          });
                        },
                        child: GenderButton(
                          gender: 'Male',
                          color: selectedGender == 'Male'
                              ? Colors.blue
                              : Colors.blueAccent[100],
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGender = 'Female';
                          });
                        },
                        child: GenderButton(
                          gender: 'Female',
                          color: selectedGender == 'Female'
                              ? Colors.pink
                              : Color.fromARGB(255, 255, 172, 200),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: selectedGender.isEmpty ? null : _handleContinue,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Continue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGender.isEmpty
                          ? Colors.grey
                          : Colors.blueAccent[100],
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            PredictionLoadingOverlay(
              currentState: _loadingState,
              progress: _loadingProgress,
            ),
        ],
      ),
    );
  }
}

class GenderButton extends StatelessWidget {
  final String gender;
  final Color? color;

  GenderButton({required this.gender, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (color != null)
            BoxShadow(
              color: color!.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
            ),
        ],
      ),
      child: Center(
        child: Text(
          gender,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
