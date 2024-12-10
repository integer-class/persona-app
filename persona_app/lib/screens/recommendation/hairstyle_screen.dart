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
      title: 'Product Recommendations',
      theme: ThemeData.dark(),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

class HairstyleScreen extends StatefulWidget {
  @override
  _hairstylescreenState createState() => _hairstylescreenState();
}

class _hairstylescreenState extends State<HairstyleScreen> {
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
      return;
    } else {
      final product = _products[_selectedProductIndex!];
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
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(RouteConstants.editRoute),
        ),
        title: const Text(
          'Recommendation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                          // Product Image Container
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade800,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    product['imageUrl']!,
                                    width: double.infinity,
                                    height: 400,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Navigation Buttons inside image
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: _currentIndex > 0
                                              ? () {
                                                  _pageController.previousPage(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                  );
                                                }
                                              : null,
                                          child: const Icon(Icons.arrow_back,
                                              size: 20, color: Colors.white),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(8),
                                            shape: const CircleBorder(),
                                            backgroundColor:
                                                Colors.grey.shade800,
                                            minimumSize: const Size(40, 40),
                                            maximumSize: const Size(40, 40),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: _currentIndex <
                                                  _products.length - 1
                                              ? () {
                                                  _pageController.nextPage(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut,
                                                  );
                                                }
                                              : null,
                                          child: const Icon(Icons.arrow_forward,
                                              size: 20, color: Colors.white),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(8),
                                            shape: const CircleBorder(),
                                            backgroundColor:
                                                Colors.grey.shade800,
                                            minimumSize: const Size(40, 40),
                                            maximumSize: const Size(40, 40),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Product Description
                                Text(
                                  product['description']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
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
              ],
            ),

            // Selection Button - Positioned at bottom center with consistent width
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_selectedProductIndex == _currentIndex) {
                          _selectedProductIndex = null;
                        } else {
                          _selectedProductIndex = _currentIndex;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedProductIndex == _currentIndex
                          ? Colors.green
                          : Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      _selectedProductIndex == _currentIndex
                          ? 'Selected'
                          : 'Select this recommendation',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
