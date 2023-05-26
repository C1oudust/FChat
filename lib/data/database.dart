import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_chatgpt_app/models/session.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:flutter_chatgpt_app/data/converter/datetime_converter.dart';
import 'package:flutter_chatgpt_app/data/dao/message_dao.dart';
import 'package:flutter_chatgpt_app/data/dao/session_dao.dart';
import 'package:flutter_chatgpt_app/models/message.dart';


part 'database.g.dart';

@Database(version: 1, entities: [Message, Session])
@TypeConverters([DateTimeConverter])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;
  SessionDao get sessionDao;
}