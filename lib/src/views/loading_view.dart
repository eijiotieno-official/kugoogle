import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final int progress;
  const LoadingView({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return progress > 0 && progress < 100
        ? LinearProgressIndicator(value: progress / 100)
        : SizedBox.shrink();
  }
}
