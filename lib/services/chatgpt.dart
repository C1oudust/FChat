import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/models/message.dart';
import 'package:openai_api/openai_api.dart';
import 'package:tiktoken/tiktoken.dart';

import '../env.dart';

final maxTokens = {Model.gpt3_5Turbo: 4096, Model.gpt4: 8192};

extension on List<ChatMessage> {
  List<ChatMessage> limit({Model model = Model.gpt3_5Turbo}) {
    assert(maxTokens[model] != null, "model not support");
    var messages = <ChatMessage>[];
    final encoding = encodingForModel(model.value);
    final maxToken = maxTokens[model];
    var count = 0;
    if (isEmpty) {
      return messages;
    }
    for (var i = length - 1; i >= 0; i--) {
      final m = this[i];
      count = count + encoding.encode(m.role.toString() + m.content).length;
      if (count <= maxToken!) {
        messages.insert(0, m);
      }
    }

    return messages;
  }
}

class ChatGPTService {
  final client = OpenaiClient(
    config: OpenaiConfig(
      apiKey: Env.apiKey,
      // baseUrl: "",  // 如果有自建OpenAI服务请设置这里
      httpProxy: Env.httpProxy, // 代理服务地址
    ),
  );

  Future<ChatCompletionResponse> sendChat(String content) async {
    final request = ChatCompletionRequest(model: Model.gpt3_5Turbo, messages: [ChatMessage(content: content, role: ChatMessageRole.user)]);
    return await client.sendChatCompletion(request);
  }

  Future streamChat(List<Message> messages, {Model model = Model.gpt3_5Turbo, Function(String text)? onSuccess}) async {
    final request = ChatCompletionRequest(
        model: model, stream: true, messages: messages.map((e) => ChatMessage(content: e.content, role: e.isUser ? ChatMessageRole.user : ChatMessageRole.assistant)).toList().limit());
    return await client.sendChatCompletionStream(request, onSuccess: (p0) {
      final text = p0.choices.first.delta?.content;
      if (text != null) {
        onSuccess?.call(text);
      }
    });
  }

  Future<String> speechToText(String path) async {
       final res = await client.createTrascription(TranscriptionRequest(file: path));
       logger.v(res);
       return res.text;
  }
}
