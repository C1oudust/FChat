import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_api/openai_api.dart';
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
      Locale? locale,
      @Default('gpt-3.5-turbo') String model}) = _Settings;

  static Future<Settings> load() async {
    final apiKey = await localStorage.get<String>(SettingKey.apiKey.name);
    final baseUrl = await localStorage.get<String>(SettingKey.baseUrl.name);
    final httpProxy = await localStorage.get<String>(SettingKey.httpProxy.name);
    final themeMode = await localStorage.get(SettingKey.themeMode.name) ??
        ThemeMode.system.index;
    final locale = await localStorage.get<String?>(SettingKey.locale.name);
    final model = await localStorage.get<String?>(SettingKey.model.name) ??
        Model.gpt3_5Turbo.name;
    return Settings(
        apiKey: apiKey,
        baseUrl: baseUrl,
        httpProxy: httpProxy,
        themeMode: ThemeMode.values[themeMode],
        locale: locale == null ? null : Locale(locale),
        model: model);
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

  Future<void> setModel(String model) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await localStorage.set(SettingKey.model.name, model);
      final settings = state.valueOrNull ?? const Settings();
      await chatgpt.loadConfig();
      return settings.copyWith(model: model);
    });
  }
}

enum SettingKey { apiKey, httpProxy, baseUrl, themeMode, locale, model }
