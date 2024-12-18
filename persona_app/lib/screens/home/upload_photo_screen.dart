import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import '../../data/datasource/local/auth_local_datasource.dart';
import '../../data/datasource/local/prediction_local_datasource.dart';
import '../../data/datasource/remote/auth_remote_datasource.dart';
import '../../data/datasource/remote/prediction_remote_datasource.dart';
import '../../data/models/user_choice_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/prediction_repository.dart';
import '../../router/app_router.dart';
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
  bool _hasShownNotification = false;

  // Metode untuk menginisialisasi data
  Future<void> _initializeData() async {
    await _checkAuthStatus(); // Check auth status dulu
    await _loadUsername(); // Kemudian load username
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    // Tambahkan pengecekan success notification di initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeState = GoRouterState.of(context);
      if (routeState.extra != null &&
          (routeState.extra as Map)['showSuccess'] == true) {
        _showSuccessNotification();
        // Clear route extra data
        context.go(RouteConstants.uploadRoute);
      }
    });
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

  void _handleProfileTap() {
    // Langsung arahkan ke login jika belum login
    if (!isLoggedIn) {
      context.go(RouteConstants.loginRoute);
      return;
    }
    context.go(RouteConstants.profileRoute);
  }

  void _showSuccessNotification() {
    // Hapus pengecekan _hasShownNotification di sini
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 16,
          right: 16,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Color.fromARGB(255, 224, 146, 146).withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Your style has been saved to history!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
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
  void dispose() {
    _hasShownNotification = false; // Reset flag when disposed
    super.dispose();
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
