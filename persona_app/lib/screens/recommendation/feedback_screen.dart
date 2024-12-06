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
      theme: ThemeData.dark(),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EnjoyAppDialog(),
            );
          },
          child: Text("Test test feedback"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue, // text color
          ),
        ),
      ),
    );
  }
}

class EnjoyAppDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enjoying this App?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Hi there! We'd love to know if you're having a great experience.",
            style: TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                  showDialog(
                    context: context,
                    builder: (context) => NotReallyDialog(),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      "😟",
                      style: TextStyle(fontSize: 32),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Not Really",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pop();
                  showDialog(
                    context: context,
                    builder: (context) => StarRatingDialog(),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      "😊",
                      style: TextStyle(fontSize: 32),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Yes!",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
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
      title: Text(
        "We’re sorry you’re not having a good time with this app.",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "Would you like to let us know how we can improve your experience?",
        style: TextStyle(fontSize: 14, color: Colors.white70),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.go(RouteConstants.feedbackRoute);
          },
          child: Text("Send Feedback"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue, 
          ),
        ),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text("Maybe Later"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue, 
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
          title: Text(
            "Rate this App",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How many stars would you give us?",
                style: TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
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
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue, // text color
              ),
            ),
          ],
        );
      },
    );
  }
}

class SendFeedbackScreen extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Feedback'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "We’d love to hear your thoughts.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: feedbackController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type your feedback here...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue), 
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final feedback = feedbackController.text;
                  print("Feedback submitted: $feedback");
                  context.pop();
                },
                child: Text("Submit Feedback"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, // text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}