import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:flutter_chatgpt_app/widgets/chat_input_widget.dart';
import 'package:flutter_chatgpt_app/widgets/chat_message_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openai_api/openai_api.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: ChatMessageList()),
          const ChatInputWidget()
        ],
      ),
    );
  }
}

extension ModelString on String {
  Model toModel() {
    return Model.values.where((e) => e.value == this).firstOrNull ??
        Model.gpt3_5Turbo;
  }
}
