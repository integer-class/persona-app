import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PredictionLoadingOverlay extends StatelessWidget {
  final String currentState;
  final double progress;

  const PredictionLoadingOverlay({
    Key? key,
    required this.currentState,
    required this.progress,
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 180,
                height: 180,
                child: Lottie.asset(
                  'assets/animations/face-scan.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Text(
                  currentState,
                  key: ValueKey<String>(currentState),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 6,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 0, end: progress),
                    builder: (context, double value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 255, 172, 200),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut, 
                tween: Tween<double>(begin: 0, end: progress),
                builder: (context, double value, _) => Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}