import 'package:flutter/material.dart';

class VerificationConfirmation extends StatefulWidget {
  const VerificationConfirmation({super.key});

  @override
  State<VerificationConfirmation> createState() =>
      _VerificationConfirmationState();
}

class _VerificationConfirmationState extends State<VerificationConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              children: [
                Text("Verification sent"),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
