import 'dart:io';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'termare_pty.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  PseudoTerminal pseudoTerminal = PseudoTerminal(
    executable: Platform.isWindows ? 'cmd' : 'sh',
    arguments: [''],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sarasa',
      ),
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   pseudoTerminal.schedulingRead();
        // }),
        body: TermarePty(
          pseudoTerminal: pseudoTerminal,
        ),
      ),
    );
  }
}
