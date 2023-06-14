import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/chat_ui.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:flutter_chatgpt_app/widgets/chat_gpt_model_widget.dart';
import 'package:flutter_chatgpt_app/widgets/chat_input_widget.dart';
import 'package:flutter_chatgpt_app/widgets/chat_message_list.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openai_api/openai_api.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeSessionProvider);
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
      body: Container(
        color: const Color(0xfff1f1f1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GptModelWidget(active: activeSession?.model.toModel(),onModelChanged: (model){
                ref.read(chatUiProvider.notifier).model = model;
              },),
              Expanded(child: ChatMessageList()), ChatInputWidget()],
          ),
        ),
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