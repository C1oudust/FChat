import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:flutter_chatgpt_app/widgets/message_markdown_content.dart';
import 'package:flutter_chatgpt_app/widgets/triangle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SendMessageItem extends StatelessWidget {
  const SendMessageItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
            child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF8FE869),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.only(left: 48),
          child: MessageMarkdownContent(
            message: message,
          ),
        )),
        const CustomPaint(
          painter: Triangle(bgColor: Color(0xFF8FE869)),
        ),
        const SizedBox(
          width: 8,
        ),
        CircleAvatar(
          backgroundColor: Colors.blue,
          child: Container(
              padding: const EdgeInsets.all(11.0),
              child: SvgPicture.asset('assets/images/user.svg')),
        )
      ],
    );
  }
}
