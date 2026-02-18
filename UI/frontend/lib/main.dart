import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MySearchEngineApp());
}

class MySearchEngineApp extends StatelessWidget {
  const MySearchEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomePage(),
    );
  }
}
