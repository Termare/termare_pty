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
        _controller.autoScroll = true;
        _controller.notifyListeners();
        await Future<void>.delayed(const Duration(microseconds: 800));
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _controller.theme.backgroundColor,
      child: TermareView(
        keyboardInput: (String data) {
          pseudoTerminal.write(data);
        },
        controller: _controller,
      ),
    );
  }
}
