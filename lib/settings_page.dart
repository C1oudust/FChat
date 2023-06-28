import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/l10n/l10n.dart';
import 'package:flutter_chatgpt_app/states/settings.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class SettingsWindow extends StatelessWidget {
  SettingsWindow({Key? key}) : super(key: key);
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ApiKey(),
        Divider(),
        HttpProxy(),
        Divider(),
        BaseUrl(),
        Divider(),
        AppTheme(),
        Divider(),
        AppLocale(),
      ],
    );
  }
}

Future<String?> showEditDialog(TextEditingController controller, WidgetRef ref, String title, {String? text, String? hint}) async {
  controller.text = text ?? '';
  return await showDialog<String?>(
      context: ref.context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: hint ?? ''),
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

class ApiKey extends HookConsumerWidget {
  const ApiKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = L10n.of(context)!.apiKey;
    final settings = ref.watch(settingsNotifierProvider).valueOrNull;
    final controller = useTextEditingController();
    return ListTile(
      title: Text(title),
      subtitle: Text(
        settings?.apiKey ?? '',
        style: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        String? text = await showEditDialog(controller, ref, title, text: settings?.apiKey, hint: L10n.of(context)!.apiKeyHint);
        if (text == null) return;
        if (text == '') {
          text = null;
        }
        ref.read(settingsNotifierProvider.notifier).setApiKey(text);
      },
    );
  }
}

class HttpProxy extends HookConsumerWidget {
  const HttpProxy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = L10n.of(context)!.httpProxy;
    final settings = ref.watch(settingsNotifierProvider).valueOrNull;
    final controller = useTextEditingController();
    return ListTile(
      title: Text(title),
      subtitle: Text(
        settings?.httpProxy ?? '',
        style: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        String? text = await showEditDialog(controller, ref, title, text: settings?.httpProxy, hint: L10n.of(context)!.httpProxyHint);
        if (text == null) return;
        if (text == '') {
          text = null;
        }
        ref.read(settingsNotifierProvider.notifier).setHttpProxy(text);
      },
    );
  }
}

class BaseUrl extends HookConsumerWidget {
  const BaseUrl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = L10n.of(context)!.baseUrl;
    final settings = ref.watch(settingsNotifierProvider).valueOrNull;
    final controller = useTextEditingController();
    return ListTile(
      title: Text(title),
      subtitle: Text(
        settings?.baseUrl ?? '',
        style: const TextStyle(overflow: TextOverflow.ellipsis),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        String? text = await showEditDialog(controller, ref, title, text: settings?.baseUrl, hint: 'https://openai.proxy.dev/v1');
        if (text == null) return;
        if (text == '') {
          text = null;
        }
        ref.read(settingsNotifierProvider.notifier).setBaseUrl(text);
      },
    );
  }
}

class AppTheme extends HookConsumerWidget {
  const AppTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsNotifierProvider).valueOrNull?.themeMode ?? ThemeMode.system;
    themeChange(theme) {
      ref.read(settingsNotifierProvider.notifier).setThemeMode(theme);
      Navigator.of(ref.context).pop();
    }

    return ListTile(
      title: Text(L10n.of(context)!.themeMode),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(L10n.of(context)!.themeMode),
                children: [
                  RadioListTile(title: Text(L10n.of(context)!.system), value: ThemeMode.system, groupValue: themeMode, onChanged: themeChange),
                  RadioListTile(title: Text(L10n.of(context)!.light), value: ThemeMode.light, groupValue: themeMode, onChanged: themeChange),
                  RadioListTile(title: Text(L10n.of(context)!.dark), value: ThemeMode.dark, groupValue: themeMode, onChanged: themeChange),
                ],
              );
            });
      },
    );
  }
}

class AppLocale extends HookConsumerWidget {
  const AppLocale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsLocale = ref.watch(settingsNotifierProvider).valueOrNull?.locale;
    localeChange(locale) {
      ref.read(settingsNotifierProvider.notifier).setLocale(locale);
      Navigator.of(ref.context).pop();
    }

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
                  RadioListTile(title: Text(L10n.of(context)!.system), value: null, groupValue: settingsLocale, onChanged: localeChange),
                  RadioListTile(title: const Text('中文'), value: const Locale('zh'), groupValue: settingsLocale, onChanged: localeChange),
                  RadioListTile(title: const Text('English'), value: const Locale('en'), groupValue: settingsLocale, onChanged: localeChange),
                ],
              );
            });
      },
    );
  }
}
