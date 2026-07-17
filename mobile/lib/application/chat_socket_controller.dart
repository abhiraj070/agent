import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/api_client.dart';

enum ChatSocketStatus { connecting, connected, disconnected }

class ChatSocketState {
  const ChatSocketState({
    this.status = ChatSocketStatus.connecting,
    this.connectionId,
  });

  final ChatSocketStatus status;
  final String? connectionId;

  ChatSocketState copyWith({
    ChatSocketStatus? status,
    String? connectionId,
    bool clearConnectionId = false,
  }) {
    return ChatSocketState(
      status: status ?? this.status,
      connectionId: clearConnectionId ? null : (connectionId ?? this.connectionId),
    );
  }
}

/// Holds one `/ws` connection open for the app session, established as
/// soon as the user reaches the main screen (per product decision — not
/// per `/chat` call). `/chat` requests use whatever `connectionId` this
/// holds; the orchestrator's `call_someone` tool fails server-side if it
/// can't find a live connection behind that ID (agent/tools.py), so a
/// missing/stale connection here means calls silently can't be placed.
///
/// This does not surface the status-push messages the socket receives
/// (call-status updates, "scheduled" acks) into the UI — that's a
/// deliberately separate, larger piece of work (live task-node status).
class ChatSocketController extends StateNotifier<ChatSocketState> {
  ChatSocketController() : super(const ChatSocketState()) {
    _connect();
  }

  static const _reconnectDelay = Duration(seconds: 4);

  WebSocket? _socket;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  bool _disposed = false;

  Future<void> _connect() async {
    if (_disposed) return;
    state = state.copyWith(status: ChatSocketStatus.connecting, clearConnectionId: true);
    try {
      final socket = await WebSocket.connect(_wsUrl());
      if (_disposed) {
        await socket.close();
        return;
      }
      _socket = socket;
      _subscription = socket.listen(
        _handleMessage,
        onDone: _handleDisconnect,
        onError: (_) => _handleDisconnect(),
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  String _wsUrl() {
    final base = Uri.parse(ApiConfig.baseUrl);
    final scheme = base.scheme == 'https' ? 'wss' : 'ws';
    return base.replace(scheme: scheme, path: '/ws').toString();
  }

  void _handleMessage(dynamic raw) {
    if (raw is! String) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final connectionId = data['connection_id'] as String?;
      if (connectionId != null) {
        state = state.copyWith(
          status: ChatSocketStatus.connected,
          connectionId: connectionId,
        );
      }
    } catch (_) {
      // Ignore frames we don't recognize (e.g. call-status pushes) — not
      // surfaced yet, see class doc comment.
    }
  }

  void _handleDisconnect() {
    _subscription?.cancel();
    _subscription = null;
    _socket = null;
    if (_disposed) return;
    state = state.copyWith(status: ChatSocketStatus.disconnected, clearConnectionId: true);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, _connect);
  }

  @override
  void dispose() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _socket?.close();
    super.dispose();
  }
}

final chatSocketControllerProvider =
    StateNotifierProvider<ChatSocketController, ChatSocketState>((ref) {
  return ChatSocketController();
});
