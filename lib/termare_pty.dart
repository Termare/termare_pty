library termare_pty;

import 'dart:convert';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:termare_view/termare_view.dart';

export 'package:dart_pty/dart_pty.dart';

class TermarePty extends StatefulWidget {
  const TermarePty({
    Key key,
    this.controller,
    this.pseudoTerminal,
    this.enableInput = true,
  }) : super(key: key);
  final TermareController controller;
  final PseudoTerminal pseudoTerminal;
  final bool enableInput;
  @override
  _TermarePtyState createState() => _TermarePtyState();
}

class _TermarePtyState extends State<TermarePty> with TickerProviderStateMixin {
  TermareController _controller;
  PseudoTerminal pseudoTerminal;
  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TermareController();

    pseudoTerminal = widget.pseudoTerminal;
    _controller.input = (String data) {
      pseudoTerminal.write(data);
    };
    _controller.sizeChanged = (TermSize size) {
      pseudoTerminal.resize(size.row, size.column);
    };
    pseudoTerminal.out.transform(utf8.decoder).listen((line) {
      _controller.writeCodeUnits(utf8.encode(line));
      _controller.enableAutoScroll();
      _controller.notifyListeners();
    });
    // init();
  }

  Future<void> init() async {
    // File file = File(
    //   '/data/data/com.nightmare.termare/neofetch.txt',
    // );
    // file.createSync();
    while (mounted) {
      final List<int> codeUnits = await pseudoTerminal.read();
      // final String cur = await compute(
      //   FileDescriptor.readSync,
      //   pseudoTerminal.pseudoTerminalId,
      // );
      // print('cur -> $cur');
      // final Uint8List pre = file.readAsBytesSync();
      // file.writeAsBytesSync(pre + utf8.encode(cur));
      if (codeUnits.isNotEmpty) {
        _controller.writeCodeUnits(codeUnits);
        _controller.enableAutoScroll();
        _controller.notifyListeners();
        await Future<void>.delayed(const Duration(milliseconds: 10));
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: TermareView(
        keyboardInput: widget.enableInput
            ? (String data) {
                pseudoTerminal.write(data);
              }
            : null,
        controller: _controller,
      ),
    );
  }
}
