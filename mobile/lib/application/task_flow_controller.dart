import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/seed_data.dart';
import '../domain/entities/activity_item.dart';
import '../domain/entities/task_node.dart';
import '../domain/entities/task_phase.dart';
import 'activity_controller.dart';

enum TaskKind { driver, shanti, paneer, generic }

class TaskFlowState {
  const TaskFlowState({
    this.phase = TaskPhase.idle,
    this.transcript = '',
    this.nodes = const [],
    this.result = '',
    this.resultSource = 'Outcome',
    this.assistantReply = '',
    this.clarification = '',
    this.missingName = '',
    this.detailOpen = false,
    this.requestPersonSheet = false,
  });

  final TaskPhase phase;
  final String transcript;
  final List<TaskNode> nodes;
  final String result;
  final String resultSource;
  final String assistantReply;
  final String clarification;
  final String missingName;
  final bool detailOpen;
  final bool requestPersonSheet;

  TaskNode? get activeNode {
    for (final node in nodes) {
      if (node.state == NodeState.calling || node.state == NodeState.preparing) {
        return node;
      }
    }
    return null;
  }

  TaskFlowState copyWith({
    TaskPhase? phase,
    String? transcript,
    List<TaskNode>? nodes,
    String? result,
    String? resultSource,
    String? assistantReply,
    String? clarification,
    String? missingName,
    bool? detailOpen,
    bool? requestPersonSheet,
  }) {
    return TaskFlowState(
      phase: phase ?? this.phase,
      transcript: transcript ?? this.transcript,
      nodes: nodes ?? this.nodes,
      result: result ?? this.result,
      resultSource: resultSource ?? this.resultSource,
      assistantReply: assistantReply ?? this.assistantReply,
      clarification: clarification ?? this.clarification,
      missingName: missingName ?? this.missingName,
      detailOpen: detailOpen ?? this.detailOpen,
      requestPersonSheet: requestPersonSheet ?? this.requestPersonSheet,
    );
  }
}

/// Ports the fake voice/call pipeline from UI_design/app/page.tsx
/// (`beginVoice`/`runTask`/`finishTask`) — same regex-based routing and
/// timer delays, so behavior matches the reference mockup exactly. Real
/// backend wiring (agent/api) replaces this controller's internals in a
/// later pass; the phase machine and UI it drives stay the same.
class TaskFlowController extends StateNotifier<TaskFlowState> {
  TaskFlowController(this._ref) : super(const TaskFlowState());

  final Ref _ref;
  final List<Timer> _timers = [];

  void _later(Duration delay, void Function() action) {
    _timers.add(Timer(delay, action));
  }

  void beginVoice() {
    if (state.phase != TaskPhase.idle) return;
    state = state.copyWith(phase: TaskPhase.listening, transcript: '');
    _later(const Duration(milliseconds: 900), () {
      state = state.copyWith(transcript: 'I’m eating paneer butter masala today…');
    });
    _later(const Duration(milliseconds: 1950), () {
      state = state.copyWith(
        transcript:
            'I’m eating paneer butter masala today. Check what we need and coordinate dinner for 8.',
      );
    });
    _later(const Duration(milliseconds: 3100), () => runTask(TaskKind.paneer));
  }

  void finishSpeakingNow() => runTask(TaskKind.paneer);

  void submitText(String draft) {
    final trimmed = draft.trim();
    if (trimmed.isEmpty) return;
    final lowered = trimmed.toLowerCase();
    final TaskKind kind;
    if (RegExp('anil|driver|gate').hasMatch(lowered)) {
      kind = TaskKind.driver;
    } else if (RegExp('shanti').hasMatch(lowered)) {
      kind = TaskKind.shanti;
    } else if (RegExp('paneer|dinner|cook').hasMatch(lowered)) {
      kind = TaskKind.paneer;
    } else {
      kind = TaskKind.generic;
    }
    runTask(kind, customText: trimmed);
  }

  void sendClarification(String detail) {
    runTask(TaskKind.generic,
        customText: 'Call maintenance for an electrician on $detail');
  }

  void runTask(TaskKind kind, {String? customText}) {
    final text = customText ?? state.transcript;
    state = state.copyWith(
      phase: TaskPhase.planning,
      clarification: '',
      assistantReply: 'Request understood. Coordinating now.',
      transcript: customText ?? state.transcript,
    );

    _later(const Duration(milliseconds: 650), () {
      if (RegExp('rahul|ramesh|unknown', caseSensitive: false).hasMatch(text)) {
        final nameMatch = RegExp(
          r'(?:ask|call)\s+([A-Za-z]+(?:\s+ji)?)',
          caseSensitive: false,
        ).firstMatch(text);
        final missing = nameMatch?.group(1) ?? 'Rahul';
        state = state.copyWith(
          missingName: missing,
          phase: TaskPhase.idle,
          assistantReply: 'I don’t have $missing in My People yet.',
          requestPersonSheet: true,
        );
        return;
      }

      final isMaintenance =
          RegExp('maintenance|electrician', caseSensitive: false).hasMatch(text);
      final hasWhen = RegExp(
        'today|tomorrow|sunday|monday|morning|afternoon|evening|[0-9]',
        caseSensitive: false,
      ).hasMatch(text);
      if (isMaintenance && !hasWhen) {
        state = state.copyWith(
          clarification: 'When should the electrician come?',
          phase: TaskPhase.idle,
          assistantReply: 'When should the electrician come?',
        );
        return;
      }

      state = state.copyWith(phase: TaskPhase.working);

      if (kind == TaskKind.driver ||
          RegExp('anil|driver|gate', caseSensitive: false).hasMatch(text)) {
        _runDriverFlow();
        return;
      }

      if (kind == TaskKind.shanti ||
          RegExp('shanti', caseSensitive: false).hasMatch(text)) {
        _runShantiFlow();
        return;
      }

      if (kind == TaskKind.paneer ||
          RegExp('paneer|dinner|cook', caseSensitive: false).hasMatch(text)) {
        _runPaneerFlow();
        return;
      }

      _runGenericFlow();
    });
  }

  void _runDriverFlow() {
    state = state.copyWith(nodes: const [
      TaskNode(id: 'anil', person: 'Anil ji', action: 'Come to the main gate', state: NodeState.calling),
    ]);
    _later(const Duration(milliseconds: 2200), () {
      state = state.copyWith(nodes: const [
        TaskNode(id: 'anil', person: 'Anil ji', action: 'Meet at Gate 2', state: NodeState.done),
      ]);
    });
    _later(const Duration(milliseconds: 3000), () {
      _finishTask('Anil ji will meet you at Gate 2.', 'Response from Anil ji', '1 call · 38 sec');
    });
  }

  void _runShantiFlow() {
    state = state.copyWith(nodes: const [
      TaskNode(id: 'shanti', person: 'Shanti', action: 'Ask when she’ll come', state: NodeState.calling),
    ]);
    _later(const Duration(milliseconds: 2600), () {
      state = state.copyWith(nodes: const [
        TaskNode(id: 'shanti', person: 'Shanti', action: 'Coming around 6 pm', state: NodeState.done),
      ]);
    });
    _later(const Duration(milliseconds: 3400), () {
      _finishTask('Shanti says she’ll come at 6 pm.', 'Response from Shanti', '1 call · 42 sec');
    });
  }

  void _runPaneerFlow() {
    final base = SeedData.paneerNodes;
    state = state.copyWith(nodes: base);
    _later(const Duration(milliseconds: 1800), () {
      state = state.copyWith(nodes: [
        base[0].copyWith(state: NodeState.done, action: 'Paneer, tomatoes & butter needed'),
        base[1].copyWith(state: NodeState.calling),
        base[2],
        base[3],
      ]);
    });
    _later(const Duration(milliseconds: 3900), () {
      state = state.copyWith(nodes: [
        base[0].copyWith(state: NodeState.done, action: 'Pantry checked'),
        base[1].copyWith(state: NodeState.done, action: 'Delivery by 6:15 pm'),
        base[2].copyWith(state: NodeState.calling),
        base[3].copyWith(state: NodeState.preparing),
      ]);
    });
    _later(const Duration(milliseconds: 5900), () {
      state = state.copyWith(nodes: [
        base[0].copyWith(state: NodeState.done, action: 'Pantry checked'),
        base[1].copyWith(state: NodeState.done, action: 'Delivery by 6:15 pm'),
        base[2].copyWith(state: NodeState.done, action: 'Dinner ready by 8 pm'),
        base[3].copyWith(state: NodeState.calling),
      ]);
    });
    _later(const Duration(milliseconds: 7600), () {
      state = state.copyWith(
        nodes: base.map((n) => n.copyWith(state: NodeState.done)).toList(),
      );
      _finishTask('Dinner coordinated for 8 pm.', 'Household outcome', '4 calls · 7 min');
    });
  }

  void _runGenericFlow() {
    state = state.copyWith(nodes: const [
      TaskNode(id: 'task', person: 'Assistant', action: 'Coordinating your request', state: NodeState.calling),
    ]);
    _later(const Duration(milliseconds: 2800), () {
      state = state.copyWith(nodes: const [
        TaskNode(id: 'task', person: 'Assistant', action: 'Request completed', state: NodeState.done),
      ]);
      _finishTask('The person confirmed your request.', 'Outcome', '1 completed request');
    });
  }

  void _finishTask(String message, String source, String meta) {
    state = state.copyWith(
      result: message,
      resultSource: source,
      phase: TaskPhase.complete,
    );
    _ref.read(activityControllerProvider.notifier).add(
          ActivityItem(time: 'Just now', title: message, meta: meta),
        );
  }

  void toggleDetail() {
    state = state.copyWith(detailOpen: !state.detailOpen);
  }

  void clearPersonSheetRequest() {
    state = state.copyWith(requestPersonSheet: false);
  }

  void reset() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    state = const TaskFlowState();
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }
}

final taskFlowControllerProvider =
    StateNotifierProvider<TaskFlowController, TaskFlowState>((ref) {
  return TaskFlowController(ref);
});
