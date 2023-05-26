import 'package:flutter_chatgpt_app/injection.dart';
import 'package:flutter_chatgpt_app/models/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session.g.dart';
part 'session.freezed.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    required List<Session> sessionList,
    required Session? activeSession,
  }) = _SessionState;
}

@riverpod
class SessionStateNotifier extends _$SessionStateNotifier {
  Future<List<Session>> _fetchData() async {
    return await db.sessionDao.findAllSessions();
  }

  @override
  FutureOr<SessionState> build() async {
    final sessionList = await _fetchData();
    return SessionState(sessionList: sessionList, activeSession: null);
  }

  Future<Session> upsertSesion(Session session) async {
    var active = session;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final id = await db.sessionDao.upsertSession(session);
      active = active.copyWith(id: id);
      return SessionState(
          sessionList: await _fetchData(), activeSession: active);
    });
    return active;
  }

  Future<void> deleteSession(Session session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await db.sessionDao.deleteSession(session);
      return SessionState(
          sessionList: await _fetchData(),
          activeSession: state.valueOrNull?.activeSession);
    });
  }

  Future<void> setActiveSession(Session? session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return SessionState(
          sessionList: state.valueOrNull?.sessionList ?? [],
          activeSession: session);
    });
  }
}

@riverpod
Session? activeSession(ActiveSessionRef ref) {
  final state = ref.watch(sessionStateNotifierProvider).valueOrNull;
  return state?.activeSession;
}