import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookSearchPage(),
    );
  }
}

