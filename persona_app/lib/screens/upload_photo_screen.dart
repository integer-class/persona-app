import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'genderselectionscreen.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  io.File? _dummyFile; // File dummy yang akan digunakan.

  @override
  void initState() {
    super.initState();
    // Simulasikan file dummy (bisa menggunakan file lokal yang sudah ada di proyek).
    _dummyFile = io.File('assets/images/dummy_photo.jpg'); // Ganti dengan file aktual.
  }

  void _navigateToGenderSelection() {
    if (_dummyFile != null) {
      Navigator.pushNamed(
        context,
        '/gender_selection',
        arguments: {'file': _dummyFile}, // Kirim file dummy sebagai argument.
      );
    } else {
      print("Dummy file not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Hello, Jessica Tjiu!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                  onPressed: _navigateToGenderSelection, // Langsung navigasi tanpa memilih file.
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



// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io' as io;

// class UploadPhotoScreen extends StatefulWidget {
//   const UploadPhotoScreen({Key? key}) : super(key: key);

//   @override
//   _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
// }

// class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;

//   Future<void> _pickImage() async {
//     // Check platform and select image accordingly
//     if (io.Platform.isAndroid || io.Platform.isIOS) {
//       // For mobile devices, use image_picker
//       final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
//       setState(() {
//         _image = selectedImage;
//       });
//     } else {
//       // For web and desktop, use file_picker
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//       );
//       if (result != null && result.files.isNotEmpty) {
//         setState(() {
//           _image = XFile(result.files.first.path!);
//         });
//       }
//     }

//     if (_image != null) {
//       print('Image selected: ${_image!.path}');
//     } else {
//       print('No image selected.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/img-main1.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 50),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: AssetImage('assets/images/profile.png'),
//                     ),
//                     const SizedBox(width: 10),
//                     const Text(
//                       "Hello, Jessica Tjiu!",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       "Recognize your",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 50,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "Personality",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 255, 172, 200),
//                         fontSize: 50,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "Reveal your true style with personalized recommendations for hairstyles, accessories, and more, tailored just for you",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _pickImage,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     backgroundColor: Color(0xFF92A5FF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   child: const Text(
//                     'Upload Photo',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
