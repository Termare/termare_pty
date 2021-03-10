import 'package:dart_pty/dart_pty.dart' hide PseudoTerminal;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pty/pty.dart';
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

    _controller = widget.controller ?? TermareController();

    pseudoTerminal = widget.pseudoTerminal ?? PseudoTerminal.start('cmd', []);
    _controller.input = (String data) {
      pseudoTerminal.write(data);
    };
    _controller.sizeChanged = (TermSize size) {
      pseudoTerminal.resize(size.column, size.row);
    };

    init();
  }

  Future<void> init() async {
    pseudoTerminal.out.listen((event) {
      print('event -> $event');
      _controller.write(event);
      _controller.autoScroll = true;
      _controller.notifyListeners();
    });
    await Future.delayed(Duration(seconds: 1), () {
      // pseudoTerminal.write('pwd');
    });
    // while (mounted) {
    //   final String cur = await pseudoTerminal.out;
    //   // final String cur = await compute(
    //   //   FileDescriptor.readSync,
    //   //   pseudoTerminal.pseudoTerminalId,
    //   // );
    //   // print('cur -> $cur');
    //   if (cur.isNotEmpty) {
    //     _controller.write(cur);
    //     _controller.autoScroll = true;
    //     _controller.notifyListeners();
    //     await Future<void>.delayed(const Duration(milliseconds: 1));
    //   } else {
    //     await Future<void>.delayed(const Duration(milliseconds: 20));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _controller.theme.backgroundColor,
      child: SafeArea(
        child: TermareView(
          keyboardInput: (String data) {
            pseudoTerminal.write(data);
          },
          controller: _controller,
        ),
      ),
    );
  }
}
