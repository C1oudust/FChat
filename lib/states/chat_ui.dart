import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatUIState{
  final bool requestLoading;
  ChatUIState({this.requestLoading = false});
}

class ChatUIStateProvider  extends StateNotifier<ChatUIState>{
  ChatUIStateProvider ():super(ChatUIState());
  void setRequestLoading(bool loading){
    state = ChatUIState(requestLoading: loading);
  }
}

final chatUiProvider = StateNotifierProvider<ChatUIStateProvider, ChatUIState>(
      (ref) => ChatUIStateProvider(),
);