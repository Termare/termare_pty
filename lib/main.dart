import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'termare_pty.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sarasa',
      ),
      home: Scaffold(
        body: TermarePty(
          pseudoTerminal: PseudoTerminal(
            executable: 'sh',
            arguments: ['-l'],
          ),
        ),
      ),
    );
  }
}
