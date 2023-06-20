import 'package:flutter_chatgpt_app/injection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings.freezed.dart';

part 'settings.g.dart';

@freezed
abstract class Settings with _$Settings {
  const factory Settings({String? apiKey, String? httpProxy, String? baseUrl}) =
      _Settings;

  static Future<Settings> load() async {
    final apiKey = await localStorage.get<String>(SettingKey.apiKey.name);
    final baseUrl = await localStorage.get<String>(SettingKey.baseUrl.name);
    final httpProxy = await localStorage.get<String>(SettingKey.httpProxy.name);
    return Settings(apiKey: apiKey, baseUrl: baseUrl, httpProxy: httpProxy);
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  FutureOr<Settings> build() async {
    return await Settings.load();
  }

  Future<void> setApiKey(String? apiKey) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await localStorage.set(SettingKey.apiKey.name, apiKey);
      final settings = state.valueOrNull ?? const Settings();
      await chatgpt.loadConfig();
      return settings.copyWith(apiKey: apiKey);
    });
  }

  Future<void> setBaseUrl(String? baseUrl) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await localStorage.set(SettingKey.baseUrl.name, baseUrl);
      final settings = state.valueOrNull ?? const Settings();
      await chatgpt.loadConfig();
      return settings.copyWith(baseUrl: baseUrl);
    });
  }

  Future<void> setHttpProxy(String? httpProxy) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await localStorage.set(SettingKey.httpProxy.name, httpProxy);
      final settings = state.valueOrNull ?? const Settings();
      await chatgpt.loadConfig();
      return settings.copyWith(httpProxy: httpProxy);
    });
  }
}

enum SettingKey {
  apiKey,
  httpProxy,
  baseUrl,
}

@freezed
class SettingItem with _$SettingItem {
  const factory SettingItem({
    required SettingKey key,
    required String title,
    String? subtitle,
    @Default(false) bool multiline,
    required String hint,
  }) = _SettingItem;
}

@riverpod
List<SettingItem> settingList(SettingListRef ref) {
  final settings = ref.watch(settingsNotifierProvider).valueOrNull;

  return [
    SettingItem(
      key: SettingKey.apiKey,
      title: "API Key",
      subtitle: settings?.apiKey,
      hint: "Please input API Key",
    ),
    SettingItem(
        key: SettingKey.httpProxy,
        title: "HTTP Proxy",
        subtitle: settings?.httpProxy,
        hint: "Please input HTTP Proxy"),
    SettingItem(
        key: SettingKey.baseUrl,
        title: "Reverse proxy URL",
        subtitle: settings?.baseUrl,
        hint: "https://openai.proxy.dev/v1"),
  ];
}
