import 'package:flutter/material.dart';

void main() => runApp(new HelloWorldApp());

class HelloWorldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Material(
        child: new Center(
          child: new Text("Hello siti!"),
        ),
      ),
    );
  }
}