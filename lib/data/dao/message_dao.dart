import 'package:floor/floor.dart';
import 'package:flutter_chatgpt_app/models/message.dart';

@dao
abstract class MessageDao {
  @Query('SELECT * FROM Message')
  Future<List<Message>> findAllMessages();

  @Query('SELECT * FROM Message WHERE id = :id')
  Future<List<Message>> findMessageById(String id);

  @Query('SELECT * FROM Message WHERE session_id = :sessionId')
  Future<List<Message>> findMessagesBySessionId(int sessionId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertMessage(Message message);

  @delete
  Future<void> deleteMessage(Message message);
}