import 'package:flutter/material.dart';
import 'accessories_screen.dart';
import 'glasses_screen.dart';
import 'hairstyle_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: EditScreen(),
    );
  }
}

class EditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        title: Text('Edit'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/jessica.png', // Replace with your image path
              ),
            ),
          ),
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hair Style Button
                GestureDetector(
                  onTap: () {
                    // Navigate to Hairstyle Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => hairstylescreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/hairstyle.png', 
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Hair Styles',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Glasses Button
                GestureDetector(
                  onTap: () {
                    // Navigate to Glasses Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => glassesscreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/glasses.png', // Icon for glasses
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Glasses',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Accessory Button
                GestureDetector(
                  onTap: () {
                    // Navigate to Accessory Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => accessoriesscreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/accessorry.png', // Icon for accessories
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Accessory',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark(),
//       home: EditScreen(),
//     );
//   }
// }

// class EditScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back action
//           },
//         ),
//         title: Text('Edit'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               child: Image.asset(
//                 'assets/images/jessica.png',
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.black,
//             padding: EdgeInsets.symmetric(vertical: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Hair Style Button
//                 Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/hairstyle.png', // Icon hair style dari assets
//                       width: 40,
//                       height: 40,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Hair Styles',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 // Glasses Button
//                 Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/glasses.png', // Icon glasses dari assets
//                       width: 40,
//                       height: 40,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Glasses',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 // Accessory Button
//                 Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/accessorry.png', // Icon accessory dari assets
//                       width: 40,
//                       height: 40,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Accessory',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
