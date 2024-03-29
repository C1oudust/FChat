import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_app/l10n/l10n.dart';
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
                  padding: EdgeInsets.only(top: 24),
                  child: NewChatBtn(),
                ),
                const Expanded(child: ChatHistory()),
                const Divider(
                  height: 1.0,
                ),
                Material(
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(L10n.of(context)!.settings),
                    onTap: () async {
                      return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              title: Text(L10n.of(context)!.settings),
                              content: SizedBox(
                                width: 400,
                                height: 420,
                                child: SettingsWindow(),
                              ),
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          ),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: ChatScreen(),
          ))
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
        title: Text(L10n.of(context)!.chat),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     GoRouter.of(context).push('/history');
          //   },
          //   icon: const Icon(Icons.history),
          // ),
          IconButton(
            onPressed: () {
              ref.read(sessionStateNotifierProvider.notifier).setActiveSession(null);
            },
            icon: const Icon(Icons.add),
          ),
          // IconButton(
          //     onPressed: () {
          //       GoRouter.of(context).push('/settings');
          //     },
          //     icon: const Icon(Icons.settings)),
        ],
      ),
      drawer: Drawer(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Text(
            L10n.of(context)!.history,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Expanded(
          child: ChatHistory(),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(L10n.of(context)!.settings),
          onTap: () {
            Navigator.of(context).pop();
            GoRouter.of(context).push('/settings');
          },
        )
      ])),
      body: GestureDetector(
        onTap: () {
          // 安卓软键盘收起
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: const ChatScreen(),
      ),
    );
  }
}
