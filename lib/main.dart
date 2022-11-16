import 'package:flutter/material.dart';
import 'dogListView.dart';

void main() async {
  runApp(const DogApp());
}

class DogApp extends StatelessWidget {
  const DogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dog App',
      home: DogListView()
    );
  }
}

