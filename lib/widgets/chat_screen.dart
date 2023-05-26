import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:flutter_chatgpt_app/widgets/chat_message_input.dart';
import 'package:flutter_chatgpt_app/widgets/chat_message_list.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chat'),
        actions: [
          IconButton(
              onPressed: () {
                GoRouter.of(context).push('/history');
              },
              icon: const Icon(Icons.history)),
          IconButton(
            onPressed: () {
              ref.read(sessionStateNotifierProvider.notifier).setActiveSession(null);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [Expanded(child: ChatMessageList()), ChatMessageInput()],
        ),
      ),
    );
  }
}
