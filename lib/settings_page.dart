import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/l10n/l10n.dart';
import 'package:flutter_chatgpt_app/states/settings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.settings),
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
                  child: Text(L10n.of(context)!.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    onPressed: () {
                      final text = controller.text;
                      Navigator.of(context).pop(text);
                    },
                    child: Text(L10n.of(context)!.confirm))
              ],
            ));
  }

  Widget radioLocaleListTile(WidgetRef ref, String title, Locale? locale) {
    final settingsLocale =
        ref.watch(settingsNotifierProvider).valueOrNull?.locale;
    return SimpleDialogOption(
        child: ListTile(
      title: Text(title),
      leading: Radio<Locale?>(
        value: locale,
        groupValue: settingsLocale,
        onChanged: null,
      ),
      onTap: () {
        ref.read(settingsNotifierProvider.notifier).setLocale(locale);
        Navigator.of(ref.context).pop();
      },
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(settingListProvider);
    final themeMode =
        ref.watch(settingsNotifierProvider).valueOrNull?.themeMode ??
            ThemeMode.system;

    return ListView.separated(
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.key == SettingKey.themeMode) {
          return ListTile(
              title: Text(item.title),
              subtitle: Row(
                children: [
                  RadioMenuButton(
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: (value) {
                        ref
                            .read(settingsNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.system);
                      },
                      child: Text(L10n.of(context)!.system)),
                  RadioMenuButton(
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    onChanged: (value) {
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .setThemeMode(ThemeMode.light);
                    },
                    child: Text(L10n.of(context)!.light),
                  ),
                  RadioMenuButton(
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    onChanged: (value) {
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .setThemeMode(ThemeMode.dark);
                    },
                    child: Text(L10n.of(context)!.dark),
                  )
                ],
              ));
        }
        if (item.key == SettingKey.locale) {
          return ListTile(
            title: Text(L10n.of(context)!.locale),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text(L10n.of(context)!.locale),
                      children: [
                        radioLocaleListTile(
                            ref, L10n.of(context)!.system, null),
                        radioLocaleListTile(ref, '中文', const Locale('zh')),
                        radioLocaleListTile(ref, 'English', const Locale('en')),
                      ],
                    );
                  });
            },
          );
        }
        return ListTile(
          title: Text(item.title),
          subtitle: Text(
            item.subtitle ?? '',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
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
