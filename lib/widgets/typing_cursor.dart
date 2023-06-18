import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TypingCursor extends HookWidget {
  const TypingCursor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 400));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    final opacity = useAnimation(Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(controller));
    if (!controller.isAnimating) {
      controller.forward();
    }
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        width: 6,
        height: 12,
        color: Colors.black,
      ),
    );
  }
}
