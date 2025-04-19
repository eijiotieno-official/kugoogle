import 'package:flutter/material.dart';

// A simple loading bar widget that displays a linear progress indicator
// only when the page is still loading (i.e., progress is between 1 and 99)
class LoadingView extends StatelessWidget {
  // The current progress value from 0 to 100
  final int progress;

  // Constructor that requires a progress value
  const LoadingView({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return (progress > 0 && progress < 100)
        // Show a linear progress bar with fractional progress (0.0 to 1.0)
        ? LinearProgressIndicator(value: progress / 100)
        // If progress is 0 or 100, hide the widget entirely to save space
        : SizedBox.shrink();
  }
}
