import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openai_api/openai_api.dart';

class ChatUIState {
  final bool requestLoading;
  final Model model;
  ChatUIState({this.requestLoading = false, this.model = Model.gpt3_5Turbo});
}

class ChatUIStateProvider extends StateNotifier<ChatUIState> {
  ChatUIStateProvider() : super(ChatUIState());
  void setRequestLoading(bool loading) {
    state = ChatUIState(requestLoading: loading);
  }

  set model(Model model) {
    state = ChatUIState(
      model: model,
    );
  }
}

final chatUiProvider = StateNotifierProvider<ChatUIStateProvider, ChatUIState>(
  (ref) => ChatUIStateProvider(),
);
