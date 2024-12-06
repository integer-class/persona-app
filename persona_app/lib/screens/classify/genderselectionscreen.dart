import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';

class GenderSelectionScreen extends StatefulWidget {
  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String selectedGender = ''; // Untuk menyimpan gender yang dipilih
  dynamic selectedFile; // Simpan file yang diterima melalui arguments

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: selectedGender.isEmpty
                  ? null
                  : () {
                      if (selectedFile != null) {
                        context.go(
                          RouteConstants.editRoute,
                          extra: {
                            'file': selectedFile,
                            'gender': selectedGender,
                          },
                        );
                      } else {
                        print('File is null. Cannot navigate to /edit.');
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedGender.isEmpty
                    ? Colors.grey
                    : Colors.blueAccent[100],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Continue'),
            ),
          ],
        ),
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