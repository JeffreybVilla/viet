
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const VietnameseApp());
}

class VietnameseApp extends StatelessWidget {
  const VietnameseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learn Vietnamese',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}