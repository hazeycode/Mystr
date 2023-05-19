import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'main_page.dart';
import 'profile_page.dart';
import 'relays_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileModel()),
        ChangeNotifierProvider(create: (context) => RelaysModel()),
      ],
      child: const MystrApp(),
    )
  );
}

/// The root app widget
class MystrApp extends StatelessWidget {
  const MystrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mystr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => MainPage(),
        '/home': (context) => MainPage(),
        '/profile': (context) => const ProfilePage(),
        '/relays': (context) => RelaysPage(),
      },
    );
  }
}
