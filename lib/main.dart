import 'package:flutter/material.dart';
import 'package:myshop/auth/auth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shop',
      theme: ThemeData(
        primaryColor: Colors.green.shade700,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white,
          secondary: Colors.green.shade900,
          tertiary: Colors.black,
        ),
        secondaryHeaderColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
