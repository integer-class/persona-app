import 'package:flutter/material.dart';
import 'package:persona_app/screens/editscreen.dart';

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
      home: accessoriesscreen(),
    );
  }
}

class accessoriesscreen extends StatefulWidget {
  @override
  _accessoriesscreenState createState() => _accessoriesscreenState();
}

class _accessoriesscreenState extends State<accessoriesscreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0; // To track the current page
  int? _selectedProductIndex; // To track the saved product index
  final List<Map<String, String>> _products = [
    {
      'imageUrl':
          'https://clubmagichour.com/cdn/shop/files/AlignedinHarmonyEarrings.png?v=1716918974',
      'title': ' Long Drop Earrings',
      'description':
          'Long drop earrings are a type of jewelry that features a hanging design, typically extending downward from the earlobe. They come in a variety of styles, from elegant and simple to ornate and intricate. Long drop earrings often feature one or multiple decorative elements such as gemstones, crystals, beads, or metalwork that create a striking visual effect ',
    },
    {
      'imageUrl':
          'https://kamaria.com/cdn/shop/products/double-slider-lariat-necklace-gold-lifestyle-1_5000x.jpg?v=1601482418',
      'title': 'Lariat Necklaces',
      'description':
          'Lariat necklaces are a versatile and elegant jewelry piece known for their unique design that helps create a flattering oval or elongated look. These necklaces typically consist of a long, flexible chain or cord that loops around the neck, with the ends hanging down loosely. ',
    },
    {
      'imageUrl':
          'https://thelittlecatholic.com/cdn/shop/products/F3321728-571E-4BAE-9023-E684A98D8946.jpg?v=1699378968',
      'title': 'Chunky Necklaces',
      'description':
          'Chunky necklaces are bold, statement-making jewelry pieces that feature thick, large links or bold elements. They are designed to stand out and draw attention, often serving as the centerpiece of an outfit. The key characteristic of chunky necklaces is their size—these necklaces typically feature oversized beads, links, or pendants made from a variety of materials, such as metal, resin, wood, or stones',
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

    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(), 
      ),
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
