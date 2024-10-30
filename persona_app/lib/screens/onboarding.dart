import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Our App",
      "description": "Discover personalized hairstyles, accessories, and more.",
      "image": "assets/images/img-onb1.png", // Image path
    },
    {
      "title": "Upload. Detect. Get Styled!",
      "description": "Get tailored recommendations for your perfect style.",
      "image": "assets/images/img-onb2.png", // Image path
    },
    {
      "title": "Ready To Transform? Start Now!",
      "description": "Explore your new look with personalized suggestions. It’s style, made for you!",
      "image": "assets/images/img-onb3.png", // Image path
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity, // Set width to fill the screen
            height: double.infinity, // Set height to fill the screen
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                // Full-screen image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(onboardingData[index]["image"]!),
                      fit: BoxFit.cover, // Ensure the image covers the entire container
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 200, // Adjusted height of the dark container
                    decoration: BoxDecoration(
                      color: Color(0xFF313130),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 28.0, right: 28.0), // Adjusted top padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8), // Reduced space between title and description
                          Opacity(
                            opacity: 0.80,
                            child: Text(
                              onboardingData[index]["description"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30), // Added space between description and buttons
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 30,
                  child: TextButton(
                    onPressed: () {
                      // Skip to the main screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 30,
                  child: TextButton(
                    onPressed: () {
                      // Move to the next page
                      if (_currentIndex < onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        // If on the last page, navigate to the main screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main Screen")),
      body: Center(child: Text("Welcome to the Main Screen!")),
    );
  }
}