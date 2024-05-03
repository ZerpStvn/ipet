import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipet/admin/pages/home.admin.dart';
import 'package:ipet/client/controller/signup.dart';
import 'package:ipet/client/pages/home.user.dart';
import 'package:ipet/controller/signup.dart';
import 'package:ipet/firebase_options.dart';
import 'package:ipet/model/Authprovider.dart';
import 'package:ipet/veterinary/home.vet.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProviderClass>(
            create: (context) => AuthProviderClass())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ipet',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff78AEA8)),
          useMaterial3: true,
        ),
        routes: {
          '/pet': (context) => const ClientRegister(),
          '/vet': (context) => const SignupController(isvet: true),
          '/vetuser': (context) => const HomeScreenVeterinary()
        },
        initialRoute: '/',
        home: kIsWeb ? const HomeAdmin() : const HomeUser(),
      ),
    );
  }
}
