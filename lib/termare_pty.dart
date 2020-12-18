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
    this.autoFocus = false,
  }) : super(key: key);
  final TermareController controller;
  final PseudoTerminal pseudoTerminal;
  final bool autoFocus;
  @override
  _TermarePtyState createState() => _TermarePtyState();
}

class _TermarePtyState extends State<TermarePty> with TickerProviderStateMixin {
  TermareController _controller;
  double curOffset = 0;
  double lastLetterOffset = 0;
  int textSelectionOffset = 0;
  // UnixPtyC unixPtyC;
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
    String dynamicLibPath = 'libterm.so';
    // print(FileSystemEntity.parentOf(Platform.resolvedExecutable));
    // AssetBundle()
    if (Platform.isMacOS) {
      dynamicLibPath =
          '/Users/nightmare/Desktop/termare-space/dart_pty/dynamic_library/libterm.dylib';
      // dynamicLibPath = 'libterm.dylib';
    }
    if (Platform.isLinux) {
      dynamicLibPath =
          '/home/nightmare/文档/termare/dart_pty/dynamic_library/libterm.so';
    }
    pseudoTerminal = widget.pseudoTerminal ?? PseudoTerminal();
    init();
  }

  Future<void> init() async {
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      // unixPtyC.write('cat /proc/version\n');
      // unixPty.write('ssh root@192.168.43.1\n');
      Future<void>.delayed(const Duration(milliseconds: 400), () {
        // unixPty.write('mys906262255\n');
        Future<void>.delayed(const Duration(milliseconds: 100), () {
          // unixPty.write('neofetch\n');
        });
      });
    });
    if (widget.autoFocus) {}
    while (mounted) {
      final String cur = pseudoTerminal.readSync();
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
