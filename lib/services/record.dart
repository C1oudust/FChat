import 'dart:io';

import 'package:flutter_chatgpt_app/injection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordService {
  final r = Record();

  Future start(String? fileName) async {
    if (await r.hasPermission()) {
      if (await isRecording) {
        logger.e("is recording...");
        return;
      }
      final path = await getTemporaryDirectory();
      final d = Directory("${path.absolute.path}/audios");
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

  bool isApplePlatform() {
    return Platform.isIOS || Platform.isMacOS;
  }

  Future<String?> stop() async {
    final path =  await r.stop();
    logger.v("stop path: $path");
    if (path == null) {
      return null;
    }
    return isApplePlatform() ? Uri.parse(path).toFilePath() : path;
  }

  dispose() {
    r.dispose();
  }
  Future<bool> get isRecording => r.isRecording();
}
