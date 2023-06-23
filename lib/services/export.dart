import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/models/session.dart';
import 'package:flutter_chatgpt_app/utils.dart';

class ExportService {
  Future exportMarkdown(Session session, {String? filename}) async {
    final messages = await db.messageDao.findMessagesBySessionId(session.id!);
    final buffer = StringBuffer();
    for (var message in messages) {
      var content = message.content;
      if (message.isUser) {
        content = "> $content";
      }

      buffer.writeln();
      buffer.writeln(content);
    }
    // logger.v(buffer.toString());
    // 安卓 ios平台不支持saveFile
    final url = isDesktop()
        ? await FilePicker.platform.saveFile(
            dialogTitle: '导出',
            fileName: "${filename ?? session.id}.md",
            type: FileType.custom,
            allowedExtensions: ['md'],
          )
        : await FilePicker.platform.getDirectoryPath(
            dialogTitle: '导出',
          );
    if (url == null) return false;
    final file = isDesktop() ? File(url) : File("$url/${session.title}.md");
    await file.writeAsString(buffer.toString());
    return true;
  }
}
