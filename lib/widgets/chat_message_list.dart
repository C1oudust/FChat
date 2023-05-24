
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/message.dart';
import 'package:flutter_chatgpt_app/widgets/message_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatMessageList extends HookConsumerWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref){
    final messages = ref.watch(messageProvider);
    return ListView.separated(
        itemBuilder: (context, index) {
          return MessageItem(
            message: messages[index],
          );
        },
        separatorBuilder: (context, index) => const Divider(
          height: 16,
        ),
        itemCount: messages.length);
  }
}
