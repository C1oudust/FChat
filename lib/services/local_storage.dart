import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  final localStorage = LocalStorage('chatgpt');

  Future<T?> get<T>(String key) async {
    await localStorage.ready;
    return localStorage.getItem(key) as T?;
  }

  Future<void> set(String key, dynamic value) async {
    await localStorage.setItem(key, value);
  }
}
