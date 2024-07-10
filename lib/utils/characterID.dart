// ignore_for_file: file_names

import 'dart:math';

String generateRandomString() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  String result = '';

  for (int i = 0; i < 5; i++) {
    result += chars[random.nextInt(chars.length)];
  }

  return result;
}
