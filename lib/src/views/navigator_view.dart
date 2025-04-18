import 'package:flutter/material.dart';

class NavigatorView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onForward;
  const NavigatorView({
    super.key,
    required this.onBack,
    required this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        IconButton(
          onPressed: onForward,
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ],
    );
  }
}
