import 'dart:io';

bool isDesktop() {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

bool isApplePlatform() {
  return Platform.isIOS || Platform.isMacOS;
}