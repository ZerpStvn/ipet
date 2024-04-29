import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipet/admin/pages/home.admin.dart';
import 'package:ipet/client/pages/home.user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ipet',
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffbacd92)),
        useMaterial3: true,
      ),
      home: kIsWeb ? const HomeAdmin() : const HomeUser(),
    );
  }
}
