import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt_app/services/chatgpt.dart';
import 'package:logger/logger.dart';
final chatgpt = ChatGPTService();
final logger = Logger(level: kDebugMode ? Level.verbose : Level.info);