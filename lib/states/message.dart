import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message.g.dart';

class MessageList extends StateNotifier<List<Message>> {
  MessageList() : super([]) {
    init();
  }

  Future<void> init() async {
    state = await db.messageDao.findAllMessages();
  }

  void addMessage(Message message) {
    state = [...state, message];
  }

  void upsertMessage(Message partialMessage) {
    final index = state.indexWhere((element) => element.id == partialMessage.id);

    var message = partialMessage;
    if (index >= 0) {
      final msg = state[index];
      message = partialMessage.copyWith(content: msg.content + partialMessage.content);
    }
    logger.d("message id ${message.toString()}");

    db.messageDao.upsertMessage(message);

    if (index == -1) {
      state = [...state, message];
    } else {
      state = [...state]..[index] = message;
    }
  }
}

final messageProvider = StateNotifierProvider<MessageList, List<Message>>(
  (ref) => MessageList(),
);

@riverpod
List<Message> activeSessionMessages(ActiveSessionMessagesRef ref) {
  final active = ref.watch(activeSessionProvider);
  final messages = ref.watch(messageProvider.select((value) =>
      value.where((element) => element.sessionId == active?.id).toList()));
  return messages;
}