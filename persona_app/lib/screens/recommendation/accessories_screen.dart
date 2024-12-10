import 'package:flutter/material.dart';
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

class AccessoriesScreen extends StatefulWidget {
  @override
  _AccessoriesScreenState createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int? _selectedProductIndex;
  final List<Map<String, String>> _products = [
    {
      'imageUrl':
          'https://clubmagichour.com/cdn/shop/files/AlignedinHarmonyEarrings.png?v=1716918974',
      'title': ' Long Drop Earrings',
      'description':
          'Long drop earrings are a type of jewelry that features a hanging design, visual effect ',
    },
    {
      'imageUrl':
          'https://kamaria.com/cdn/shop/products/double-slider-lariat-necklace-gold-lifestyle-1_5000x.jpg?v=1601482418',
      'title': 'Lariat Necklaces',
      'description':
          'Lariat necklaces are a versatile and elegant jewelry piece known for their unique, down loosely. ',
    },
    {
      'imageUrl':
          'https://thelittlecatholic.com/cdn/shop/products/F3321728-571E-4BAE-9023-E684A98D8946.jpg?v=1699378968',
      'title': 'Chunky Necklaces',
      'description':
          'Chunky necklaces are bold, statement-making jewelry pieces that feature thick, wood, or stones',
    },
  ];

  void _onSave() {
    if (_selectedProductIndex != null) {
      context.go(RouteConstants.editRoute);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(RouteConstants.editRoute),
        ),
        title: Text(
          'Recommendation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
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
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                                        backgroundColor: Colors.grey.shade800,
                                        minimumSize: const Size(40, 40),
                                        maximumSize: const Size(40, 40),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          _currentIndex < _products.length - 1
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
                                        backgroundColor: Colors.grey.shade800,
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
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['title']!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
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
      ),
    );
  }
}
