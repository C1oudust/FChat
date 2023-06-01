import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/models/session.dart';
import 'package:flutter_chatgpt_app/states/chat_ui.dart';
import 'package:flutter_chatgpt_app/states/message.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:flutter_chatgpt_app/widgets/chat_screen.dart';
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

  Message _createMessage(
    String content, {
    String? id,
    bool isUser = true,
    int? sessionId,
  }) {
    final message = Message(
      id: id ?? uuid.v4(),
      content: content,
      isUser: isUser,
      timestamp: DateTime.now(),
      sessionId: sessionId ?? 0,
    );
    return message;
  }

  _requestChatGPT(WidgetRef ref, String content, {int? sessionId}) async {
    ref.read(chatUiProvider.notifier).setRequestLoading(true);
    final uiState = ref.watch(chatUiProvider);
    final messages = ref.watch(activeSessionMessagesProvider);
    final activeSession = ref.watch(activeSessionProvider);
    try {
      // final res = await chatgpt.sendChat(content);
      // final text = res.choices.first.message?.content ?? "";
      // final message = Message(id: uuid.v4(), content: text, isUser: false, timestamp: DateTime.now());
      // ref.read(messageProvider.notifier).addMessage(message);
      final id = uuid.v4();
      await chatgpt.streamChat(messages, model: activeSession?.model.toModel() ?? uiState.model, onSuccess: (text) {
        final message = _createMessage(text, id: id, isUser: false, sessionId: sessionId);
        ref.read(messageProvider.notifier).upsertMessage(message);
      });
    } catch (err) {
      final id = uuid.v4();
      logger.e("request chatgpt error: $err", err);
      final message = _createMessage("暂无GPT4 使用权限", id: id, isUser: false, sessionId: sessionId);
      ref.read(messageProvider.notifier).upsertMessage(message);
    } finally {
      ref.read(chatUiProvider.notifier).setRequestLoading(false);
    }
  }

  _sendMessage(WidgetRef ref, String content) async {
    if (content.isEmpty) return;
    Message message = _createMessage(content);

    final uiState = ref.watch(chatUiProvider);
    var active = ref.watch(activeSessionProvider);
    var sessionId = active?.id ?? 0;
    if (sessionId <= 0) {
      active = Session(title: content, model: uiState.model.value);
      active = await ref.read(sessionStateNotifierProvider.notifier).upsertSesion(active);
      sessionId = active.id!;
      ref.read(sessionStateNotifierProvider.notifier).setActiveSession(active.copyWith(id: sessionId));
    }
    ref.read(messageProvider.notifier).upsertMessage(
          message.copyWith(sessionId: sessionId),
        );
    _textController.clear();
    _requestChatGPT(ref, content, sessionId: sessionId);
  }
}
