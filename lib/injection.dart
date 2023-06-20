import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt_app/data/database.dart';
import 'package:flutter_chatgpt_app/services/chatgpt.dart';
import 'package:flutter_chatgpt_app/services/local_storage.dart';
import 'package:flutter_chatgpt_app/services/record.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
final chatgpt = ChatGPTService();
final recorder = RecordService();
final localStorage = LocalStorageService();
final logger = Logger(level: kDebugMode ? Level.verbose : Level.info);
const uuid = Uuid();
late AppDatabase db;
setupDatabse() async {
  db = await initDatabase();
}