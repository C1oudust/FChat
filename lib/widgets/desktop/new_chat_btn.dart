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
              textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.titleMedium,
              ),
              iconSize:
                  MaterialStateProperty.all(Theme.of(context).iconTheme.size),
              alignment: Alignment.centerLeft,
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              iconColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.titleMedium?.color),
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.titleMedium?.color),
            ),
            onPressed: () {
              ref
                  .read(sessionStateNotifierProvider.notifier)
                  .setActiveSession(null);
            },
            icon: const Icon(
              Icons.add,
            ),
            label: const Text('New Chat')),
      ),
    );
  }
}
