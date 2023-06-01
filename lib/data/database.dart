import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_chatgpt_app/models/session.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:flutter_chatgpt_app/data/converter/datetime_converter.dart';
import 'package:flutter_chatgpt_app/data/dao/message_dao.dart';
import 'package:flutter_chatgpt_app/data/dao/session_dao.dart';
import 'package:flutter_chatgpt_app/models/message.dart';


part 'database.g.dart';

@Database(version: 2, entities: [Message, Session])
@TypeConverters([DateTimeConverter])
abstract class AppDatabase extends FloorDatabase {
  MessageDao get messageDao;
  SessionDao get sessionDao;
}

Future<AppDatabase> initDatabase() async {
  return await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([
    Migration(1, 2, (database) async {
      await database.execute('ALTER TABLE Session ADD COLUMN model TEXT');
      await database.execute("UPDATE Session SET model = 'gpt-3.5-turbo'");
    }),
  ]).build();
}