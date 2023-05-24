import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/markdown/code_wrapper.dart';
import 'package:flutter_chatgpt_app/markdown/latex.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MessageMarkdownContent extends StatelessWidget {
  const MessageMarkdownContent({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: MarkdownGenerator(config: MarkdownConfig().copy(configs: [const PreConfig().copy(wrapper: codeWrapper)]), generators: [latexGenerator], inlineSyntaxes: [LatexSyntax()])
            .buildWidgets(message.content),
      ),
    );
  }
}
