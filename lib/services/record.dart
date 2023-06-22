import 'dart:io';

import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordService {
  final r = Record();

  getTempPath() async {
    if (Platform.isAndroid) {
      final dirs = await getExternalCacheDirectories();
      return dirs?[0].absolute.path;
    }
    final dir = await getTemporaryDirectory();
    return dir.absolute.path;
  }

  Future start(String? fileName) async {
    if (await r.hasPermission()) {
      if (await isRecording) {
        logger.e("is recording...");
        return;
      }
      final path = await getTempPath();
      final d = Directory("$path/audios");
      await d.create(recursive: true);
      final file = File(
          "${d.path}/${fileName ?? DateTime.now().microsecondsSinceEpoch}.m4a");
      logger.v("start path: ${file.path}");
      try {
        await r.start(
          // IOS MACOS应用需要使用Uri格式
          path: isApplePlatform() ? Uri.file(file.path).toString() : file.path,
        );
      } catch (e) {
        logger.e(e.toString());
      }
    } else {
      logger.e("permission denied");
    }
  }

  Future<String?> stop() async {
    // return null;
    final path = await r.stop();
    logger.v("stop path: $path");
    if (path == null) {
      return null;
    }
    return isApplePlatform() ? Uri.parse(path).toFilePath() : path;
  }

  clear(path) async {
    final file = File(path);
    if (file.existsSync()) {
      logger.v('delete path file $path');
      file.deleteSync();
    }
  }

  dispose() {
    r.dispose();
  }

  Future<bool> get isRecording => r.isRecording();
}
