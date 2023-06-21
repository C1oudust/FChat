import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/widgets/chat_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: const ChatHistory(),
    );
  }
}
