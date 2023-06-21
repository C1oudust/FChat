import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/settings_page.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:flutter_chatgpt_app/utils.dart';
import 'package:flutter_chatgpt_app/widgets/chat_history.dart';
import 'package:flutter_chatgpt_app/widgets/chat_screen.dart';
import 'package:flutter_chatgpt_app/widgets/desktop/desktop_window.dart';
import 'package:flutter_chatgpt_app/widgets/desktop/new_chat_btn.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDesktop() ? const DesktopHomeScreen() : const MobileHomeScreen();
  }
}

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesktopWindow(
          child: Row(
        children: [
          SizedBox(
            width: 240,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 24, bottom: 8.0),
                  child: NewChatBtn(),
                ),
                const Expanded(child: ChatHistory()),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () async{
                    return await showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('Settings'),
                        content: SizedBox(
                          width: 400,
                          height: 400,
                          child: SettingsWindow(),
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(child: ChatScreen())
        ],
      )),
    );
  }
}

class MobileHomeScreen extends HookConsumerWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push('/history');
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              ref
                  .read(sessionStateNotifierProvider.notifier)
                  .setActiveSession(null);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                GoRouter.of(context).push('/settings');
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: const ChatScreen(),
    );
  }
}
