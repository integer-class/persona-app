import 'package:flutter/material.dart';
import 'edit_screen.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Glasses Recommendations',
      theme: ThemeData.dark(),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

class GlassesScreen extends StatefulWidget {
  @override
  _glassesscreenState createState() => _glassesscreenState();
}

class _glassesscreenState extends State<GlassesScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; // To track the current page
  int? _selectedProductIndex; // To track the saved product index
  final List<Map<String, String>> _products = [
    {
      'imageUrl':
          'https://www.giantvintage.com/cdn/shop/products/GIN_smokeclear2_W.jpeg?v=1699509023&width=1200',
      'title': 'Cat-eye Glasses',
      'description':
          'The epitome of understated glam, cat-eye glasses have upper corners (the ones nearest your temples) with an upswept shape, almost as though they’re implying thick eyelashes. Their distinctive, curvy browline has led them to be characterized as a feminine glasses style, but rest assured, anyone can wear cat-eyes to great effect. ',
    },
    {
      'imageUrl':
          'https://res.glassesshop.com/categories/63154c663fe9c.jpg',
      'title': 'Rectangle Glasses',
      'description':
          'Rectangle glasses are a staple of the frame world for a reason: they’re almost universally flattering. Their lenses are wider than they are tall, with even, straight borders and rounded corners. They’re a simple, sophisticated, and reliable shape, but you can give them as much pizzazz as you like with bold colors.',
    },
    {
      'imageUrl':
          'https://www.vintandyork.com/cdn/shop/collections/7e443cc42e0bc642828c600ffb46de3a.jpg?v=1654530896&width=2048',
      'title': 'Oval Glasses',
      'description':
          'A bit more wide than circular frames, and more rounded than rectangular ones, oval glasses have a smooth, chic look that can play well with sharper or more angular features. Their frames can be thick or wire-thin, making them an attractively flexible option for wearers.',
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

    context.go(RouteConstants.editRoute, extra: {
      'product': product,
    });
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