import 'package:flutter/material.dart';

class SnackbarMessage extends StatelessWidget {
  final String message;
  const SnackbarMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: SnackBar(
        content: Text(message),
      ),
    );
  }
}
