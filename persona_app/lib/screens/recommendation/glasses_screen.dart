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
          'The epitome of understated glam, cat-eye glasses have upper corners (the ones nearest your temples) with an upswept shape, almost as though theyre ',
    },
    {
      'imageUrl': 'https://res.glassesshop.com/categories/63154c663fe9c.jpg',
      'title': 'Rectangle Glasses',
      'description':
          'Rectangle glasses are a staple of the frame world for a reason: theyre almost universally flattering. Their lenses are wider than they are tall, with even, straight borders and rounded corners.',
    },
    {
      'imageUrl':
          'https://www.vintandyork.com/cdn/shop/collections/7e443cc42e0bc642828c600ffb46de3a.jpg?v=1654530896&width=2048',
      'title': 'Oval Glasses',
      'description':
          'A bit more wide than circular frames, and more rounded than rectangular ones, oval glasses have a smooth, chic look that can play well with sharper or more angular features.',
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
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade800),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
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
                // Selection Button at bottom
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
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
                            : 'Select this Recommendation',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
