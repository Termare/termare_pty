import 'dart:io';
import 'dart:ui';
import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:termare_view/termare_view.dart';

class TermarePty extends StatefulWidget {
  const TermarePty({
    Key key,
    this.controller,
    this.pseudoTerminal,
  }) : super(key: key);
  final TermareController controller;
  final PseudoTerminal pseudoTerminal;
  @override
  _TermarePtyState createState() => _TermarePtyState();
}

class _TermarePtyState extends State<TermarePty> with TickerProviderStateMixin {
  TermareController _controller;
  PseudoTerminal pseudoTerminal;
  @override
  void initState() {
    super.initState();
    final Size size = window.physicalSize;

    final double screenWidth = size.width / window.devicePixelRatio;
    final double screenHeight = size.height / window.devicePixelRatio;
    // 行数
    final int row = screenHeight ~/ TermareStyles.termux.letterHeight;
    // 列数
    final int column = screenWidth ~/ TermareStyles.termux.letterWidth;
    print('$this < row : $row column : $column>');
    _controller = widget.controller ?? TermareController();
    _controller.setPtyWindowSize(size);
    String executable = 'sh';
    if (Platform.isWindows) {
      executable = 'powershell';
    } else if (Platform.isMacOS) {
      executable = 'bash';
    }
    if (widget.pseudoTerminal != null) {
      pseudoTerminal = widget.pseudoTerminal;
    } else {
      pseudoTerminal = PseudoTerminal(executable: executable);
    }
    init();
  }

  Future<void> init() async {
    while (mounted) {
      final String cur = await pseudoTerminal.read();
      print('cur -> cur');
      if (cur.isNotEmpty) {
        _controller.write(cur);
        _controller.autoScroll = true;
        _controller.notifyListeners();
        await Future<void>.delayed(const Duration(milliseconds: 10));
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'sarasa',
      ),
      child: TermareView(
        keyboardInput: (String data) {
          pseudoTerminal.write(data);
        },
        controller: _controller,
      ),
    );
  }
}
