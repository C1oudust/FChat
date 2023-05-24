import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/widgets/message_markdown_content.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: message.isUser ? Colors.blue : Colors.grey,
          child: Text(
            message.isUser ? 'A' : 'GPT',
            style:const TextStyle(color: Colors.white70)
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(child: Container(
          padding: const EdgeInsets.only(right: 20),
          child: MessageMarkdownContent(message: message,),
        ))
      ],
    );
  }
}
