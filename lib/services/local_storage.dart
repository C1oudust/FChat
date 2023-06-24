import 'package:flutter_chatgpt_app/utils.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  //安卓会报错没有chatgpt文件夹
  // windows位于 用户名/document文件夹下
  final localStorage = isDesktop()
      ? LocalStorage('chatgpt/config.json')
      : LocalStorage('config.json');

  Future<T?> get<T>(String key) async {
    await localStorage.ready;
    return localStorage.getItem(key) as T?;
  }

  Future<void> set(String key, dynamic value) async {
    await localStorage.setItem(key, value);
  }
}
