import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/models/session.dart';
import 'package:flutter_chatgpt_app/states/chat_ui.dart';
import 'package:flutter_chatgpt_app/states/message.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:flutter_chatgpt_app/widgets/chat_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatInputWidget extends HookConsumerWidget {
  const ChatInputWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceMode = useState(false);
    final chatUIState = ref.watch(chatUiProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      height: 42,
      child: Row(
        children: [
          IconButton(
            onPressed: chatUIState.requestLoading
                ? null
                : () {
                    voiceMode.value = !voiceMode.value;
                  },
            icon: Icon(
              voiceMode.value ? Icons.keyboard : Icons.keyboard_voice,
              color: Colors.blue,
            ),
          ),
          Expanded(
              child: voiceMode.value ? const AudioInput() : ChatMessageInput()),
        ],
      ),
    );
  }
}

class AudioInput extends HookConsumerWidget {
  const AudioInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recording = useState(false);
    final transcripting = useState(false);
    final chatUIState = ref.watch(chatUiProvider);
    return chatUIState.requestLoading || transcripting.value
        ? SizedBox(
            height: 36,
            child: ElevatedButton(
                onPressed: null,
                child: Text(
                    transcripting.value ? "Transcripting..." : "Loading...")),
          )
        : GestureDetector(
            onLongPressStart: (details) {
              recording.value = true;
              recorder.start(null);
            },
            onLongPressEnd: (details) async {
              recording.value = false;
              final path = await recorder.stop();
              if (path == null) {
                return;
              }
              try {
                transcripting.value = true;
                final text = await chatgpt.speechToText(path);
                recorder.clear(path);
                transcripting.value = false;
                if (text.trim().isNotEmpty) {
                  __sendMessage(ref, text);
                }
              } catch (err) {
                logger.e("err: $err", err);
                transcripting.value = false;
              }
            },
            onLongPressCancel: () {
              recording.value = false;
              recorder.stop();
            },
            child: ElevatedButton(
              onPressed: () {},
              child: Text(recording.value ? 'Recording...' : 'Hold to speak'),
            ),
          );
  }
}

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
          _sendMessage(ref, _textController);
        }
      },
      child: TextField(
          controller: _textController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: 'input a message',
            suffixIcon: SizedBox(
                width: 40,
                child: chatUIState.requestLoading
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          _sendMessage(ref, _textController);
                        },
                        icon: const Icon(Icons.send),
                      )),
          )),
    );
  }
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
    await chatgpt.streamChat(messages,
        model: activeSession?.model.toModel() ?? uiState.model,
        onSuccess: (text) {
      final message =
          _createMessage(text, id: id, isUser: false, sessionId: sessionId);
      ref.read(messageProvider.notifier).upsertMessage(message);
    });
  } catch (err) {
    final id = uuid.v4();
    logger.e("request chatgpt error: $err", err);
    final message = _createMessage("暂无 GPT 使用权限",
        id: id, isUser: false, sessionId: sessionId);
    ref.read(messageProvider.notifier).upsertMessage(message);
  } finally {
    ref.read(chatUiProvider.notifier).setRequestLoading(false);
  }
}

_sendMessage(WidgetRef ref, TextEditingController controller) async {
  final content = controller.text;
  controller.clear();
  return __sendMessage(ref, content);
}

__sendMessage(WidgetRef ref, String content) async {
  if (content.isEmpty) return;
  Message message = _createMessage(content);

  final uiState = ref.watch(chatUiProvider);
  var active = ref.watch(activeSessionProvider);
  var sessionId = active?.id ?? 0;
  if (sessionId <= 0) {
    active = Session(title: content, model: uiState.model.value);
    active = await ref
        .read(sessionStateNotifierProvider.notifier)
        .upsertSesion(active);
    sessionId = active.id!;
    ref
        .read(sessionStateNotifierProvider.notifier)
        .setActiveSession(active.copyWith(id: sessionId));
  }
  ref.read(messageProvider.notifier).upsertMessage(
        message.copyWith(sessionId: sessionId),
      );
  _requestChatGPT(ref, content, sessionId: sessionId);
}
