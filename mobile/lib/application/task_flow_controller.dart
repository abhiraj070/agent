import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/audio_recorder.dart';
import '../data/remote/api_exception.dart';
import '../domain/entities/task_phase.dart';
import 'account_setup_controller.dart';
import 'activity_controller.dart';
import 'app_stage_controller.dart';
import 'chat_socket_controller.dart';
import 'onboarding_controller.dart';
import 'providers.dart';

class TaskFlowState {
  const TaskFlowState({
    this.phase = TaskPhase.idle,
    this.transcript = '',
    this.assistantReply = '',
    this.result = '',
    this.errorMessage = '',
    this.detailOpen = false,
  });

  final TaskPhase phase;
  final String transcript;
  final String assistantReply;
  final String result;
  final String errorMessage;
  final bool detailOpen;

  TaskFlowState copyWith({
    TaskPhase? phase,
    String? transcript,
    String? assistantReply,
    String? result,
    String? errorMessage,
    bool? detailOpen,
  }) {
    return TaskFlowState(
      phase: phase ?? this.phase,
      transcript: transcript ?? this.transcript,
      assistantReply: assistantReply ?? this.assistantReply,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      detailOpen: detailOpen ?? this.detailOpen,
    );
  }
}

/// Drives the home screen's phase machine (idle → listening → planning →
/// working → complete). Two separate real paths feed it, both landing on
/// the same real outcome text via [_finishTask]:
///
/// - Voice: [beginVoice] records real audio; [finishSpeakingNow] stops
///   the recording and uploads it as-is to `POST /receive-audio-file`.
///   No transcription happens client-side — the backend transcribes and
///   runs the orchestrator, returning the same outcome shape as the text
///   path.
/// - Text ("type instead"): [submitText] → [runTask] → `POST
///   /recieve-message` directly, since it's already text.
///
/// Both need a live `/ws` connection behind `connection_id` (see
/// [ChatSocketController]) or the orchestrator's calls fail server-side;
/// if that connection isn't up yet, this surfaces as [errorMessage]
/// rather than attempting the call.
class TaskFlowController extends StateNotifier<TaskFlowState> {
  TaskFlowController(this._ref) : super(const TaskFlowState());

  final Ref _ref;
  final AppAudioRecorder _audioRecorder = AppAudioRecorder();

  Future<void> beginVoice() async {
    if (state.phase != TaskPhase.idle) return;
    if (!await _ensureAuthenticated()) return;

    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      state = state.copyWith(
        errorMessage: 'Aaraam needs microphone access — enable it in Settings.',
      );
      return;
    }

    try {
      await _audioRecorder.start();
    } catch (_) {
      state = state.copyWith(errorMessage: 'Couldn’t start recording. Try again.');
      return;
    }

    state = state.copyWith(phase: TaskPhase.listening, transcript: '', errorMessage: '');
  }

  /// Stops recording and uploads the file to `/receive-audio-file`.
  /// `working` doubles as the "uploading" state here — there's no
  /// separate phase for it, since the underlying phase machine is shared
  /// with the text/chat path and this keeps that machine untouched.
  Future<void> finishSpeakingNow() async {
    if (state.phase != TaskPhase.listening) return;
    if (!await _ensureAuthenticated()) return;

    final connectionId = _ref.read(chatSocketControllerProvider).connectionId;
    if (connectionId == null) {
      await _discardRecording();
      state = state.copyWith(
        phase: TaskPhase.idle,
        errorMessage: 'Still connecting — give it a second and try again.',
      );
      return;
    }

    String? path;
    try {
      path = await _audioRecorder.stop();
      if (path == null) {
        state = state.copyWith(
          phase: TaskPhase.idle,
          errorMessage: 'Didn’t catch that — try again.',
        );
        return;
      }
      state = state.copyWith(
        phase: TaskPhase.working,
        assistantReply: 'Sending your recording…',
        errorMessage: '',
      );
      final response = await _ref.read(audioRepositoryProvider).uploadRecording(
            filePath: path,
            connectionId: connectionId,
          );
      _finishTask(response);
    } on ApiException catch (e) {
      state = state.copyWith(phase: TaskPhase.idle, errorMessage: e.message);
    } finally {
      if (path != null) {
        await _audioRecorder.deleteFile(path);
      }
    }
  }

  Future<void> _discardRecording() async {
    final path = await _audioRecorder.stop();
    if (path != null) {
      await _audioRecorder.deleteFile(path);
    }
  }

  void submitText(String draft) {
    final trimmed = draft.trim();
    if (trimmed.isEmpty) return;
    runTask(trimmed);
  }

  /// Guards every path into `/chat`: if there's no stored session, this
  /// bounces straight to the phone-verification step of onboarding
  /// (step 3) instead of letting the request go out and fail with a 401.
  /// Also resets the account-setup sub-flow back to its phone-entry stage
  /// — that controller is long-lived and may still be sitting on
  /// `language` from a prior successful run, which would otherwise show
  /// the wrong screen at step 3.
  Future<bool> _ensureAuthenticated() async {
    final tokens = await _ref.read(secureTokenStorageProvider).read();
    if (tokens != null) return true;
    _ref.read(accountSetupControllerProvider.notifier).changeNumber();
    _ref.read(onboardingControllerProvider.notifier).goToStep(3);
    _ref.read(appStageControllerProvider.notifier).enterOnboarding();
    return false;
  }

  Future<void> runTask(String text) async {
    if (!await _ensureAuthenticated()) return;

    state = state.copyWith(
      phase: TaskPhase.planning,
      transcript: text,
      assistantReply: 'Request understood. Coordinating now.',
      errorMessage: '',
    );

    final connectionId = _ref.read(chatSocketControllerProvider).connectionId;
    if (connectionId == null) {
      state = state.copyWith(
        phase: TaskPhase.idle,
        errorMessage: 'Still connecting — give it a second and try again.',
      );
      return;
    }

    state = state.copyWith(phase: TaskPhase.working);
    try {
      final response = await _ref
          .read(chatRepositoryProvider)
          .sendMessage(connectionId: connectionId, message: text);
      _finishTask(response);
    } on ApiException catch (e) {
      state = state.copyWith(phase: TaskPhase.idle, errorMessage: e.message);
    }
  }

  /// The backend already wrote this task to the `Activity` table as a
  /// side effect of the call that just resolved — this only refreshes the
  /// Activity list from there so it's ready by the time the user checks
  /// it, rather than relying on the list's own fetch-on-open.
  void _finishTask(String message) {
    state = state.copyWith(result: message, phase: TaskPhase.complete);
    _ref.read(activityControllerProvider.notifier).refresh();
  }

  void toggleDetail() {
    state = state.copyWith(detailOpen: !state.detailOpen);
  }

  void reset() {
    if (state.phase == TaskPhase.listening) {
      // Release the mic and discard whatever was captured — the user
      // navigated away mid-recording.
      _audioRecorder.stop().then((path) {
        if (path != null) _audioRecorder.deleteFile(path);
      });
    }
    state = const TaskFlowState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }
}

final taskFlowControllerProvider =
    StateNotifierProvider<TaskFlowController, TaskFlowState>((ref) {
  return TaskFlowController(ref);
});
