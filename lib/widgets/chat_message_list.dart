import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/chat_ui.dart';
import 'package:flutter_chatgpt_app/states/message.dart';
import 'package:flutter_chatgpt_app/theme.dart';
import 'package:flutter_chatgpt_app/widgets/received_message_item.dart';
import 'package:flutter_chatgpt_app/widgets/send_message_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatMessageList extends HookConsumerWidget {
  ChatMessageList({super.key});

  final listController = useScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(activeSessionMessagesProvider);
    final uiState = ref.watch(chatUiProvider);
    ref.listen(activeSessionMessagesProvider, (previous, next) {
      Future.delayed(const Duration(milliseconds: 50), () {
        listController.jumpTo(listController.position.maxScrollExtent);
      });
    });
    return ListView.separated(
        controller: listController,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return msg.isUser
              ? SendMessageItem(
                  message: msg,
                  backgroundColor: isDarkMode(context)
                      ? const Color(0xFF28B561)
                      : const Color(0xFF8FE869),
                )
              : ReceivedMessageItem(
                  message: msg,
                  backgroundColor: isDarkMode(context)
                      ? Colors.white10
                      : Colors.black.withOpacity(.05),
                  typing:
                      index == messages.length - 1 && uiState.requestLoading,
                );
        },
        separatorBuilder: (context, index) => const Divider(
              height: 16,
              color: Colors.transparent,
            ),
        itemCount: messages.length);
  }
}
