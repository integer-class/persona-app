import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _pulseController.forward();
        }
      });

    _pulseController.forward();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
    await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.pop(context, File(pickedFile.path));
    }
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized) return;

    try {
      final image = await _controller!.takePicture();
      Navigator.pop(context, File(image.path));
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview
            if (_isCameraInitialized)
              Center(
                child: CameraPreview(_controller!),
              ),

            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Text(
                'Position your face within the circle',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            // Face Frame Overlay
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer animated circle
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 230 * _pulseAnimation.value,
                        height: 310 *
                            _pulseAnimation.value, // Higher than width for oval
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(
                              230 * _pulseAnimation.value,
                              230 * _pulseAnimation.value,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                      );
                    },
                  ),
                  // Inner fixed circle
                  Container(
                    width: 220,
                    height: 300, // Higher than width for oval
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(150, 170),
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                  // Position guides
                  ...[
                   Positioned(top: -5, child: _buildGuideMarker()),
                    Positioned(bottom: -5, child: _buildGuideMarker()),
                    Positioned(left: -5, child: _buildGuideMarker()),
                    Positioned(right: -5, child: _buildGuideMarker()),
                  ],
                ],
              ),
            ),

            // Bottom Bar
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildControlButton(
                      icon: Icons.photo_library,
                      onPressed: _pickFromGallery,
                      backgroundColor: Colors.white24,
                    ),
                    _buildControlButton(
                      icon: Icons.camera,
                      onPressed: _takePicture,
                      backgroundColor: Colors.white,
                      iconColor: Colors.black,
                      size: 72,
                    ),
                    const SizedBox(width: 56), // Spacer
                  ],
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              child: _buildControlButton(
                icon: Icons.close,
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.black38,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideMarker() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white,
    Color iconColor = Colors.white,
    double size = 56,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
