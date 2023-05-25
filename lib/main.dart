import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/data/database.dart';
import 'package:flutter_chatgpt_app/widgets/chat_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
