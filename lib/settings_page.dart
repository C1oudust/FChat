import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/states/settings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings'),
      ),
      body: SettingsWindow(),
    );
  }
}

class SettingsWindow extends HookConsumerWidget {
  SettingsWindow({Key? key}) : super(key: key);
  final controller = TextEditingController();

  Future<String?> showEditDialog(
      TextEditingController controller, SettingItem item, WidgetRef ref) async {
    controller.text = item.subtitle ?? '';
    return await showDialog<String?>(
        context: ref.context,
        builder: (context) => AlertDialog(
              title: Text(item.title),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: item.hint),
              ),
              actions: [
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    onPressed: () {
                      final text = controller.text;
                      Navigator.of(context).pop(text);
                    },
                    child: const Text('确定'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(settingListProvider);
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.subtitle ?? ''),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            String? text = await showEditDialog(controller, item, ref);
            if (text == null) return;
            if (text == '') {
              text = null;
            }
            switch (item.key) {
              case SettingKey.apiKey:
                ref.read(settingsNotifierProvider.notifier).setApiKey(text);
                break;
              case SettingKey.baseUrl:
                ref.read(settingsNotifierProvider.notifier).setBaseUrl(text);
                break;
              case SettingKey.httpProxy:
                ref.read(settingsNotifierProvider.notifier).setHttpProxy(text);
                break;
              default:
                break;
            }
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: items.length,
    );
  }
}
