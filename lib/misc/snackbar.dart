import 'package:flutter/material.dart';

void snackbar(BuildContext context, String? title) {
  final snack = SnackBar(content: Text(title!));
  ScaffoldMessenger.of(context).showSnackBar(snack);
}
