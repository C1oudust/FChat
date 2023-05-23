import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/states/chat_ui.dart';
import 'package:flutter_chatgpt_app/states/message.dart';
import 'package:flutter_chatgpt_app/widgets/message_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatScreen extends HookConsumerWidget {
  ChatScreen({Key? key}) : super(key: key);
  final _textController = TextEditingController();
  _requestChatGPT(WidgetRef ref, String content) async {
    ref.read(chatUiProvider.notifier).setRequestLoading(true);
    try {
      final res = await chatgpt.sendChat(content);
      final text = res.choices.first.message?.content ?? "";
      final message = Message(content: text, isUser: false, timestamp: DateTime.now());
      ref.read(messageProvider.notifier).addMessage(message);
    } catch (err) {
      logger.e("request chatgpt error: $err", err);
    } finally {
      ref.read(chatUiProvider.notifier).setRequestLoading(false);
    }
  }

  _sendMessage(WidgetRef ref, String content) {
    final message = Message(content: content, isUser: true, timestamp: DateTime.now());
    ref.read(messageProvider.notifier).addMessage(message);
    _textController.clear();

    _requestChatGPT(ref, content);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider);
    final chatUIState = ref.watch(chatUiProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return MessageItem(
                      message: messages[index],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                        height: 16,
                      ),
                  itemCount: messages.length),
            ),
            TextField(
              controller: _textController,
              enabled: !chatUIState.requestLoading,
              decoration: InputDecoration(
                  hintText: 'input a message',
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _sendMessage(ref, _textController.text);
                      }
                    },
                    icon: const Icon(Icons.send),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
