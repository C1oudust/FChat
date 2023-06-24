import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/states/session.dart';
import 'package:flutter_chatgpt_app/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/session.dart';

class ChatHistory extends HookConsumerWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionStateNotifierProvider);
    return Center(
      child: state.when(
          data: (state) {
            return ListView(children: [
              for (var session in state.sessionList)
                ChatHistoryItemWidget(session: session),
            ]);
          },
          error: (err, stack) => Text("$err"),
          loading: () => const CircularProgressIndicator()),
    );
  }
}

class ChatHistoryItemWidget extends HookConsumerWidget {
  ChatHistoryItemWidget({super.key, required this.session});

  final Session session;
  final controller = useTextEditingController();

  showToast(Function fn, String title, BuildContext context) {
    fn(
      title: Text(title),
      animationType: AnimationType.fromTop,
      animationDuration: const Duration(milliseconds: 500),
      toastDuration: const Duration(milliseconds: 2000),
    ).show(context);
  }

  exportMarkdown(Session session, BuildContext context,
      {String? filename}) async {
    try {
      final res = await export.exportMarkdown(session);
      if (res) {
        showToast(CherryToast.success, 'export success', context);
      }
    } catch (e) {
      logger.e("export error $e");
      showToast(CherryToast.error, 'export failed', context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeSessionProvider);
    final editMode = useState(false);

    return ListTile(
      title: editMode.value
          ? Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  tooltip: '完成',
                  onPressed: () {
                    final text = controller.text;
                    if (text == session.title) {
                      editMode.value = false;
                      return;
                    }
                    if (text.trim().isNotEmpty) {
                      ref
                          .read(sessionStateNotifierProvider.notifier)
                          .upsertSesion(
                            session.copyWith(title: text.trim()),
                          );
                      editMode.value = false;
                    }
                  },
                  icon: const Icon(Icons.done),
                ),
                IconButton(
                  iconSize: 16,
                  tooltip: '取消',
                  onPressed: () {
                    editMode.value = false;
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
                IconButton(
                  iconSize: 16,
                  tooltip: '重命名',
                  onPressed: () {
                    controller.text = session.title;
                    editMode.value = true;
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                  ),
                ),
                active?.id == session.id
                    ? IconButton(
                        iconSize: 16,
                        tooltip: '导出',
                        onPressed: () {
                          if (active != null) {
                            exportMarkdown(session, context);
                          }
                        },
                        icon: const Icon(
                          Icons.ios_share,
                        ),
                      )
                    : Container(),
                IconButton(
                  iconSize: 16,
                  tooltip: '删除',
                  onPressed: () {
                    _deleteConfirm(context, ref, session);
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
      onTap: () {
        ref
            .read(sessionStateNotifierProvider.notifier)
            .setActiveSession(session);
        if (!isDesktop()) {
          Navigator.of(context).pop();
        }
      },
      selected: active?.id == session.id,
    );
  }
}

Future _deleteConfirm(
    BuildContext context, WidgetRef ref, Session session) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(sessionStateNotifierProvider.notifier)
                    .deleteSession(session);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      });
}
