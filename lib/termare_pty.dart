import 'dart:io';
import 'dart:ui';
import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:termare_view/termare_view.dart';

class TermarePty extends StatefulWidget {
  const TermarePty({
    Key key,
    this.controller,
    this.unixPtyC,
    this.autoFocus = false,
  }) : super(key: key);
  final TermareController controller;
  final UnixPtyC unixPtyC;
  final bool autoFocus;
  @override
  _TermarePtyState createState() => _TermarePtyState();
}

class _TermarePtyState extends State<TermarePty> with TickerProviderStateMixin {
  TermareController controller;
  double curOffset = 0;
  double lastLetterOffset = 0;
  int textSelectionOffset = 0;
  UnixPtyC unixPtyC;
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
    controller = widget.controller ??
        TermareController(
          rowLength: row - 3,
          columnLength: column - 2,
          // showBackgroundLine: true,
        );
    String dynamicLibPath = 'libterm.so';
    if (Platform.isMacOS) {
      dynamicLibPath =
          '/Users/nightmare/Desktop/termare-space/dart_pty/dynamic_library/libterm.dylib';
    }
    if (Platform.isLinux) {
      dynamicLibPath =
          '/home/nightmare/文档/termare/dart_pty/dynamic_library/libterm.so';
    }
    print('row->$row');
    print('column->$column');
    unixPtyC = widget.unixPtyC ??
        UnixPtyC(
          libPath: dynamicLibPath,
          rowLen: row,
          columnLen: column - 2,
          environment: <String, String>{
            'TERM': 'screen-256color',
          },
        );
    init();
  }

  Future<void> init() async {
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      // unixPtyC.write('cat /proc/version\n');
      unixPtyC.write('neofetch\n');
    });
    if (widget.autoFocus) {}
    while (mounted) {
      final String cur = unixPtyC.read();
      if (cur.isNotEmpty) {
        controller.write(cur);
        controller.autoScroll = true;
        controller.notifyListeners();
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
          unixPtyC.write(data);
        },
        controller: controller,
      ),
    );
  }
}
