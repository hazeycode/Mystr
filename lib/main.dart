import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'main_page.dart';
import 'profile_page.dart';
import 'relays_page.dart';

void main() async {
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileModel()),
        ChangeNotifierProvider(create: (context) {
            final Set<String> defaultRelays = {}; // TODO: Populate with default relay endpoint
            final relays = Set<String>.from(GetStorage().read('relays') ?? defaultRelays);
            return RelaysModel(relays);
        }),
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
      debugShowCheckedModeBanner: false,
      title: 'Mystr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const MainPage(),
        '/home': (context) => const MainPage(),
        '/profile': (context) => const ProfilePage(),
        '/relays': (context) => const RelaysPage(),
      },
    );
  }
}
