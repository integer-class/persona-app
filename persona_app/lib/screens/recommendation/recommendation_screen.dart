import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../data/models/prediction_model.dart';
import '../../../constant/variables.dart';

class RecommendationScreen extends StatefulWidget {
  final List<Accessory> recommendations;
  final List<Accessory> otherOptions;
  final String title;
  final String gender;
  final Prediction prediction;
  final File imageFile;
  final Accessory? selectedItem;
  final Map<String, Accessory?>? keepSelections;

  const RecommendationScreen({
    required this.recommendations,
    required this.otherOptions,
    required this.title,
    required this.gender,
    required this.prediction,
    required this.imageFile,
    this.selectedItem,
    this.keepSelections,
  });

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.selectedItem != null) {
      _selectedProductIndex =
          allItems.indexWhere((item) => item.id == widget.selectedItem!.id);
    }
  }

  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int? _selectedProductIndex;

  List<Accessory> get allItems =>
      [...widget.recommendations, ...widget.otherOptions];

  bool isRecommended(Accessory item) => widget.recommendations.contains(item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(RouteConstants.editRoute, extra: {
            'gender': widget.gender,
            'prediction': widget.prediction,
            'imageFile': widget.imageFile,
          }),
        ),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text('Save', style: TextStyle(color: Colors.white)),
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
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemCount: allItems.length,
                    itemBuilder: (context, index) {
                      final item = allItems[index];
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: EdgeInsets.all(16),
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isRecommended(item)
                                    ? Colors.green
                                    : Colors.grey.shade800,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    item.image,
                                    width: double.infinity,
                                    height: 400,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Error loading image: $error');
                                      return Container(
                                        width: double.infinity,
                                        height: 400,
                                        color: Colors.grey[800],
                                        child: Icon(Icons.error_outline,
                                            color: Colors.white),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: double.infinity,
                                        height: 400,
                                        color: Colors.grey[800],
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    },
                                  ),
                                ),
                                if (isRecommended(item))
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Recommended',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Navigation arrows
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 200,
                                  child: NavigationArrows(
                                    currentIndex: _currentIndex,
                                    itemCount: allItems.length,
                                    pageController: _pageController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  item.description,
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
            // Page Indicator at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 100, // Above selection button
              child: PageIndicator(
                currentIndex: _currentIndex,
                itemCount: allItems.length,
              ),
            ),

            // Selection button at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: SelectionButton(
                isSelected: _selectedProductIndex == _currentIndex,
                onPressed: () => setState(() {
                  if (_selectedProductIndex == _currentIndex) {
                    _selectedProductIndex = null;
                  } else {
                    _selectedProductIndex = _currentIndex;
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _onSave() {
  if (_selectedProductIndex != null) {
    final selectedItem = allItems[_selectedProductIndex!];

    // Cast keepSelections ke Map<String, Accessory>
    final Map<String, Accessory> selections =
        Map<String, Accessory>.from(widget.keepSelections ?? {});

    // Update the selections with the new selected item
    if (selectedItem.category == Category.GLASSES) {
      selections['glasses'] = selectedItem;
    } else if (selectedItem.category == Category.EARRINGS) {
      selections['earrings'] = selectedItem;
    } else {
      selections['hairstyle'] = selectedItem;
    }

    context.go(RouteConstants.editRoute, extra: {
      'gender': widget.gender,
      'prediction': widget.prediction,
      'imageFile': widget.imageFile,
      'selectedItem': selectedItem,
      'keepSelections': selections,
    });
  }
}
}

// Simplified NavigationArrows widget
// Updated NavigationArrows widget
class NavigationArrows extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final PageController pageController;

  const NavigationArrows({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button with fade
          AnimatedOpacity(
            opacity: currentIndex > 0 ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: AnimatedScale(
              scale: currentIndex > 0 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: currentIndex > 0
                      ? () {
                          HapticFeedback.lightImpact();
                          pageController.previousPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Next button with fade
          AnimatedOpacity(
            opacity: currentIndex < itemCount - 1 ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: AnimatedScale(
              scale: currentIndex < itemCount - 1 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: currentIndex < itemCount - 1
                      ? () {
                          HapticFeedback.lightImpact();
                          pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// New PageIndicator widget
class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const PageIndicator({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPressed;
  final bool isLoading; // Add this

  const SelectionButton({
    Key? key,
    required this.isSelected,
    required this.onPressed,
    this.isLoading = false, // Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                isSelected ? 'Selected' : 'Select this Item',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
