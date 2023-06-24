import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class DesktopWindow extends StatelessWidget {
  const DesktopWindow({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WindowBorder(
        color: Colors.transparent,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              child,
              WindowTitleBarBox(
                child: Row(
                  children: [
                    Expanded(child: MoveWindow()),
                    const WindowButtons(),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: Colors.white70,
    mouseDown: Colors.white54,
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
