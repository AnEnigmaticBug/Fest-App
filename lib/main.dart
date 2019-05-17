import 'package:flutter/material.dart';

void main() => runApp(FestApp());

class FestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fest App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('Home Page', style: TextStyle(fontSize: 36.0)),
          ),
        ),
      ),
    );
  }
}
