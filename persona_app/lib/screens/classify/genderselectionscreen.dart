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

      print('Prediction failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to analyze image: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
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
