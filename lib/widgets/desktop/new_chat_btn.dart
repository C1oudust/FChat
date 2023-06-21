import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewChatBtn extends HookConsumerWidget {
  const NewChatBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: SizedBox(
        height: 40,
        child: OutlinedButton.icon(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              iconColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () {
              ref
                  .read(sessionStateNotifierProvider.notifier)
                  .setActiveSession(null);
            },
            icon: const Icon(Icons.add,size: 16,),
            label: const Text('new chat')),
      ),
    );
  }
}
