import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/message.dart';
import 'package:flutter_chatgpt_app/widgets/message_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatMessageList extends HookConsumerWidget {
  ChatMessageList({super.key});
  final listController = useScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(activeSessionMessagesProvider);
    ref.listen(activeSessionMessagesProvider, (previous, next) {
      Future.delayed(const Duration(milliseconds: 50), () {
        listController.jumpTo(listController.position.maxScrollExtent);
      });
    });
    return ListView.separated(
        controller: listController,
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
