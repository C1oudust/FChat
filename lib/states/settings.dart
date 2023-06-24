import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings.freezed.dart';

part 'settings.g.dart';

@freezed
abstract class Settings with _$Settings {
  const factory Settings(
      {String? apiKey,
      String? httpProxy,
      String? baseUrl,
      @Default(ThemeMode.system) ThemeMode themeMode,
      Locale? locale}) = _Settings;

  static Future<Settings> load() async {
    final apiKey = await localStorage.get<String>(SettingKey.apiKey.name);
    final baseUrl = await localStorage.get<String>(SettingKey.baseUrl.name);
    final httpProxy = await localStorage.get<String>(SettingKey.httpProxy.name);
    final themeMode = await localStorage.get(SettingKey.themeMode.name) ??
        ThemeMode.system.index;
    final locale = await localStorage.get<String?>(SettingKey.locale.name);
    return Settings(
        apiKey: apiKey,
        baseUrl: baseUrl,
        httpProxy: httpProxy,
        themeMode: ThemeMode.values[themeMode],
        locale: locale == null ? null : Locale(locale));
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

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await localStorage.set(SettingKey.themeMode.name, themeMode.index);
      final settings = state.valueOrNull ?? const Settings();
      await chatgpt.loadConfig();
      return settings.copyWith(themeMode: themeMode);
    });
  }

  Future<void> setLocale(Locale? locale) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await localStorage.set(SettingKey.locale.name, locale.toString());
      final settings = state.valueOrNull ?? const Settings();
      await chatgpt.loadConfig();
      return settings.copyWith(locale: locale);
    });
  }
}

enum SettingKey { apiKey, httpProxy, baseUrl, themeMode, locale }

@freezed
class SettingItem with _$SettingItem {
  const factory SettingItem({
    required SettingKey key,
    required String title,
    String? subtitle,
    dynamic value,
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
    SettingItem(
        key: SettingKey.themeMode,
        title: "App Theme",
        hint: "theme mode",
        value: settings?.themeMode),
    SettingItem(
        key: SettingKey.locale,
        title: "Locale",
        hint: "locale",
        value: settings?.locale),
  ];
}
