import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/router.dart';
import 'package:flutter_chatgpt_app/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:windows_single_instance/windows_single_instance.dart';
import 'injection.dart';

void initWindow() {
  if (isDesktop()) {
    doWhenWindowReady(() {
      const initialSize = Size(800, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDatabse();
  await chatgpt.loadConfig();
  if (Platform.isWindows) {
    await WindowsSingleInstance.ensureSingleInstance(args, "flutter_chat_gpt");
  }
  runApp(const ProviderScope(
    child: MyApp(),
  ));
  initWindow();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'chat',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
