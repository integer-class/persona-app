import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Recommendations',
      theme: ThemeData.dark(),
      home: hairstylescreen(),
    );
  }
}

class hairstylescreen extends StatefulWidget {
  @override
  _hairstylescreenState createState() => _hairstylescreenState();
}

class _hairstylescreenState extends State<hairstylescreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; // To track the current page
  int? _selectedProductIndex; // To track the saved product index
  final List<Map<String, String>> _products = [
    {
      'imageUrl':
          'https://s2-ug.ap4r.com/image-aigc-article/seoPic/origin/1bb02b26836667050e723b236b9ef3e10bd1daed.jpg',
      'title': 'French Crop',
      'description':
          'The French crop is a shorter hairstyle marked by a taper fade or undercut with longer fringe on top. This look gives you the top volume while avoiding any side bulk that could add a rounder appearance.',
    },
    {
      'imageUrl':
          'https://images.squarespace-cdn.com/content/v1/5702abebd210b8e9fd0df564/252c3f25-e88c-4c1a-9996-fe44d77bb971/Swanky-Malone-High-Skin-Fade.jpg',
      'title': 'High Skin Fade',
      'description':
          'The high skin fade is the more modern, neat version of the French crop. It features super-short sides with longer strands on the side, creating a dramatic contrast between the two.',
    },
    {
      'imageUrl':
          'https://cdn.shopify.com/s/files/1/0939/4234/files/rsz_1397a6817_large.png?v=1554229564',
      'title': 'Side Part',
      'description':
          'The side part is a simple, close-clipped cut marked by a dramatic quiff contrasted by a shorter cut on the other side of the part. The contrast between short and long creates the illusion of more volume.',
    },
  ];

  void _onSave() {
    if (_selectedProductIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a recommendation to save!')),
      );
    } else {
      final product = _products[_selectedProductIndex!];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved: ${product['title']}')),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900, 
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Product Image
                      Image.network(
                        product['imageUrl']!,
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                      ),

                      // Padding around product details
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Title
                            Text(
                              product['title']!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // White text for contrast
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Product Description
                            Text(
                              product['description']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400], // Lighter text
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Save Selection Button
                           ElevatedButton(
  onPressed: () {
    setState(() {
      _selectedProductIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_products[index]['title']} selected!'),
      ),
    );
  },
  child: Text(
    _selectedProductIndex == index
        ? 'Selected'
        : 'Select this Recommendation',
    style: TextStyle(color: Colors.white), 
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: _selectedProductIndex == index
        ? Colors.green
        : Colors.grey.shade800,
    padding: const EdgeInsets.symmetric(
      horizontal: 30,
      vertical: 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  ),
),

                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Navigation Buttons (Back & Next)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (icon only)
                  ElevatedButton.icon(
                    onPressed: _currentIndex > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
                    label: const SizedBox.shrink(), // Remove text
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                  ),

                  // Save Button
                  ElevatedButton(
                    onPressed: _onSave,
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 4,
                    ),
                  ),

                  // Next Button (icon only)
                  ElevatedButton.icon(
                    onPressed: _currentIndex < _products.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward, size: 30, color: Colors.white),
                    label: const SizedBox.shrink(), // Remove text
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
