import 'package:openai_api/openai_api.dart';

import '../env.dart';

class ChatGPTService {
  final client = OpenaiClient(
    config: OpenaiConfig(
      apiKey: Env.apiKey,
      // baseUrl: "",  // 如果有自建OpenAI服务请设置这里
      httpProxy: Env.httpProxy,  // 代理服务地址
    ),
  );

  Future<ChatCompletionResponse> sendChat(String content) async{
    final request = ChatCompletionRequest(model: Model.gpt3_5Turbo, messages: [
      ChatMessage(content: content, role: ChatMessageRole.user)
    ]);
    return await client.sendChatCompletion(request);
  }


  Future streamChat(String content, {Function(String text) ? onSuccess}) async{
    final request = ChatCompletionRequest(model: Model.gpt3_5Turbo,stream: true, messages: [
      ChatMessage(content: content, role: ChatMessageRole.user)
    ]);
    return await client.sendChatCompletionStream(request,onSuccess: (p0){
      final text = p0.choices.first.delta?.content;
      if(text != null){
        onSuccess?.call(text);
      }
    });
  }
}