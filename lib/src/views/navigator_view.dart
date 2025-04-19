import 'package:flutter/material.dart';

// A simple navigation bar with back and forward buttons for WebView navigation
class NavigatorView extends StatelessWidget {
  // Callback triggered when the back button is pressed
  final VoidCallback onBack;

  // Callback triggered when the forward button is pressed
  final VoidCallback onForward;

  // Constructor requiring both callbacks
  const NavigatorView({
    super.key,
    required this.onBack,
    required this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceEvenly, // Space out the buttons evenly across the row
      children: [
        // Back button with a rounded left arrow icon
        IconButton(
          onPressed: onBack, // Calls the onBack callback when pressed
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        // Forward button with a rounded right arrow icon
        IconButton(
          onPressed: onForward, // Calls the onForward callback when pressed
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ],
    );
  }
}
