import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/widgets/message_markdown_content.dart';
import 'package:flutter_chatgpt_app/widgets/triangle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReceivedMessageItem extends StatelessWidget {
  const ReceivedMessageItem(
      {super.key,
      required this.message,
      this.typing = false,
      this.backgroundColor = Colors.white});

  final Message message;
  final Color backgroundColor;
  final bool typing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/images/chatgpt.svg')),
        ),
        const SizedBox(
          width: 8,
        ),
        CustomPaint(
          painter: Triangle(bgColor: backgroundColor),
        ),
        Flexible(
            child: Container(
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.only(right: 48),
          child: MessageMarkdownContent(
            message: message,
            typing: typing,
          ),
        ))
      ],
    );
  }
}
