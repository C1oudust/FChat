import 'dart:io';

import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

bool isDesktop() {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

bool isApplePlatform() {
  return Platform.isIOS || Platform.isMacOS;
}

showToast(Function fn, String title, BuildContext context) {
  fn(
    title: Text(title),
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 500),
    toastDuration: const Duration(milliseconds: 2000),
    backgroundColor: Theme.of(context).colorScheme.surface,
    shadowColor: Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.grey.withOpacity(0.5) : Colors.grey[900]
  ).show(context);
}