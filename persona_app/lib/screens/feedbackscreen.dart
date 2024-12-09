import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Show dialog when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        barrierColor: Colors.black, // Set barrier color to black
        builder: (context) => EnjoyAppDialog(),
      );
    });

    return Container(
      color: Colors.black, // Set background color to black
    ); // Empty container since this is just for dialog
  }
}
class EnjoyAppDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey[800],
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      title: Text(
        "Enjoying this App?",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Hi there! We'd love to know if you're having a great experience.",
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              border: Border(
                right: BorderSide(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeedbackOption(
                context: context, 
                emoji: "😟",
                text: "Not Really",
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierColor: Colors.black, // Set barrier color to black
                    builder: (context) => NotReallyDialog(),
                  );
                },
              ),
              Container(
                height: 80,
                child: VerticalDivider(
                  color: Colors.blue.withOpacity(0.3),
                  thickness: 1,
                ),
              ),
              _buildFeedbackOption(
                context: context,
                emoji: "😊", 
                text: "Yes!",
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierColor: Colors.black, // Set barrier color to black
                    builder: (context) => StarRatingDialog(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackOption({
    required BuildContext context,
    required String emoji,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 40, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}

class NotReallyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey[800],
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      title: Text(
        "We're sorry you're not having a good time with this app.",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "Would you like to let us know how we can improve your experience?",
        style: TextStyle(fontSize: 16, color: Colors.white70),
        textAlign: TextAlign.center,
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierColor: Colors.black, // Set barrier color to black
                    builder: (context) => SendFeedbackDialog(),
                  );
                },
                child: Text(
                  "Send Feedback",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Container(
                height: 40,
                child: VerticalDivider(
                  color: Colors.blue.withOpacity(0.3),
                  thickness: 1,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)..pop()..pop();
                },
                child: Text(
                  "Maybe Later",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StarRatingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selectedRating = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.grey[800],
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          title: Text(
            "Rate this App",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How many stars would you give us?",
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)..pop()..pop();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SendFeedbackDialog extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "We'd love to hear your thoughts.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
              decoration: InputDecoration(
                hintText: "Type your feedback here...",
                hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey[700],
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                final feedback = feedbackController.text;
                if (feedback.isNotEmpty) {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black, // Set barrier color to black
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      title: Text(
                        "Thank You!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        "Your feedback has been submitted successfully.",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        Container(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context)..pop()..pop()..pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                "Submit Feedback",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
