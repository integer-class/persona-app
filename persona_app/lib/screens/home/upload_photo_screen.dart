import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:persona_app/data/models/auth_model.dart';
import '../../data/datasource/local/prediction_local_datasource.dart';
import '../../data/datasource/remote/prediction_remote_datasource.dart';
import '../../data/models/user_choice_model.dart';
import '../../data/repositories/prediction_repository.dart';
import '../../router/app_router.dart';
import 'package:persona_app/data/datasource/remote/auth_remote_datasource.dart';
import 'package:persona_app/data/datasource/local/auth_local_datasource.dart';
import 'package:persona_app/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import '../../provider/selection_provider.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _selectedImage;
  String username = "Guest";
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Metode untuk menginisialisasi data
  Future<void> _initializeData() async {
    await _checkAuthStatus(); // Check auth status dulu
    await _loadUsername(); // Kemudian load username
    _checkForUserSelection(); // Check for user selection to save
  }

  Future<void> _loadUsername() async {
    try {
      final authRepository = AuthRepository(
        AuthRemoteDataSource(),
        AuthLocalDatasource(),
      );
      final authData = await authRepository.getAuthData();

      // Safely access nested properties with null check
      setState(() {
        if (authData?.data?.user?.username != null) {
          username = authData!.data!.user!.username!;
        } else {
          username = "Guest";
        }
      });
    } catch (e) {
      setState(() {
        username = "Guest";
      });
      print('Error loading username: $e');
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      final authRepository = AuthRepository(
        AuthRemoteDataSource(),
        AuthLocalDatasource(),
      );
      final isAuth = await authRepository.isAuth();
      setState(() {
        isLoggedIn = isAuth;
      });
    } catch (e) {
      setState(() {
        isLoggedIn = false;
      });
      print("Error checking auth status: $e");
    }
  }

  Future<void> _checkForUserSelection() async {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (args != null && args['userSelection'] != null) {
      final userSelection = args['userSelection'] as UserSelection;
      final predictionRepository = PredictionRepository(
        PredictionLocalDataSource(),
        PredictionRemoteDataSource(),
      );
      try {
        await predictionRepository.saveUserSelection(userSelection);
        _showSuccessDialog('User selection saved successfully.');
      } catch (e) {
        print('Error saving user selection: $e');
        _showErrorDialog('Failed to save user selection.');
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleProfileTap() {
    // Langsung arahkan ke login jika belum login
    if (!isLoggedIn) {
      context.go(RouteConstants.loginRoute);
      return;
    }
    context.go(RouteConstants.profileRoute);
  }

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _navigateToGenderSelection(File(pickedFile.path)); // Navigate immediately
    }
  }

  // Function to capture image from camera
  Future<void> _captureImageWithCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _navigateToGenderSelection(File(pickedFile.path)); // Navigate immediately
    }
  }

  void _navigateToGenderSelection(File image) {
    context.go(
      RouteConstants.genderSelectionRoute,
      extra: {'file': image},
    );
  }

  // Function to show dialog for image source selection
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context); // Close dialog
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context); // Close dialog
                _captureImageWithCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SelectionProvider>(context, listen: false).resetSelections();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img-main1.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _handleProfileTap,
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _handleProfileTap,
                      child: Text(
                        "Hello, $username!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Recognize your",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Personality",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 172, 200),
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Reveal your true style with personalized recommendations for hairstyles, accessories, and more, tailored just for you",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed:
                      _showImageSourceDialog, // Open dialog for image source
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: const Color(0xFF92A5FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Select Photo',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}