import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/states/chat_ui.dart';
import 'package:flutter_chatgpt_app/states/message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatMessageInput extends HookConsumerWidget {
  ChatMessageInput({super.key});
  final _textController = useTextEditingController();
  final _focusNode = useFocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUIState = ref.watch(chatUiProvider);

    return RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (RawKeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _sendMessage(ref, _textController.text);
          }
        },
        child: TextField(
          controller: _textController,
          enabled: !chatUIState.requestLoading,
          decoration: InputDecoration(
              hintText: 'input a message',
              suffixIcon: IconButton(
                onPressed: () {
                  _sendMessage(ref, _textController.text);
                },
                icon: const Icon(Icons.send),
              )),
        ));
  }

  _requestChatGPT(WidgetRef ref, String content) async {
    ref.read(chatUiProvider.notifier).setRequestLoading(true);
    try {
      // final res = await chatgpt.sendChat(content);
      // final text = res.choices.first.message?.content ?? "";
      // final message = Message(id: uuid.v4(), content: text, isUser: false, timestamp: DateTime.now());
      // ref.read(messageProvider.notifier).addMessage(message);
      final id = uuid.v4();
      await chatgpt.streamChat(content, onSuccess: (text) {
        final message = Message(id: id, content: text, timestamp: DateTime.now(), isUser: false);
        ref.read(messageProvider.notifier).upsertMessage(message);
      });
    } catch (err) {
      logger.e("request chatgpt error: $err", err);
    } finally {
      ref.read(chatUiProvider.notifier).setRequestLoading(false);
    }
  }

  _sendMessage(WidgetRef ref, String content) {
    if (content.isEmpty) return;
    final message = Message(id: uuid.v4(), content: content, isUser: true, timestamp: DateTime.now());
    ref.read(messageProvider.notifier).upsertMessage(message);
    _textController.clear();
    _requestChatGPT(ref, content);
  }
}
