import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/task_flow_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bottom_sheet_shell.dart';
import '../../core/widgets/pill_button.dart';
import '../../domain/entities/task_phase.dart';
import '../shared_sheets/composer_sheet.dart';
import 'widgets/execution_view.dart';
import 'widgets/listening_view.dart';
import 'widgets/mic_button.dart';
import 'widgets/result_card.dart';

/// Ports the `home-view` block from UI_design/app/page.tsx: the voice entry
/// point, the live task-execution view, and the completed-outcome card.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _headline(TaskPhase phase) {
    switch (phase) {
      case TaskPhase.listening:
        return 'I’m listening';
      case TaskPhase.planning:
        return 'I understand';
      case TaskPhase.working:
        return 'You relax.';
      case TaskPhase.complete:
        return 'Taken care of.';
      case TaskPhase.idle:
        return 'What can I take care of?';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(taskFlowControllerProvider);
    final controller = ref.read(taskFlowControllerProvider.notifier);

    final activeChore = flow.phase == TaskPhase.working || flow.phase == TaskPhase.planning;
    final subline = flow.errorMessage.isNotEmpty
        ? flow.errorMessage
        : switch (flow.phase) {
            TaskPhase.idle => 'Say it once. I’ll handle the calls.',
            TaskPhase.listening => flow.transcript.isEmpty ? 'Go ahead…' : flow.transcript,
            TaskPhase.planning => 'Turning that into a simple plan.',
            TaskPhase.working => 'Everything is moving into place.',
            TaskPhase.complete => 'Here’s what came back.',
          };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        children: [
          Text(
            activeChore ? '1 CHORE IN MOTION' : 'YOUR TIME IS YOURS',
            style: AppTextStyles.eyebrow,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 13),
          Text(_headline(flow.phase), style: AppTextStyles.headline, textAlign: TextAlign.center),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320, minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(subline, style: AppTextStyles.subline, textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(height: 8),
          if (flow.phase == TaskPhase.working || flow.phase == TaskPhase.planning)
            ExecutionView(phase: flow.phase, assistantReply: flow.assistantReply)
          else if (flow.phase == TaskPhase.complete)
            ResultCard(result: flow.result),
          if (flow.phase == TaskPhase.idle) ...[
            const SizedBox(height: 24),
            MicButton(onTap: controller.beginVoice),
            const SizedBox(height: 20),
            const Text('Tap to speak', style: TextStyle(color: Color(0xFFD6D9D7), fontSize: 12)),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => BottomSheetShell.show(
                context,
                child: ComposerSheet(onSubmit: controller.submitText),
              ),
              child: const Text(
                'or type instead',
                style: TextStyle(color: AppColors.faint, fontSize: 11),
              ),
            ),
          ] else if (flow.phase == TaskPhase.listening)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ListeningView(onDoneSpeaking: controller.finishSpeakingNow),
            ),
          if (flow.phase == TaskPhase.complete) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PillButton(
                  label: flow.detailOpen ? 'Hide details' : 'See details',
                  variant: PillButtonVariant.ghost,
                  expand: false,
                  onPressed: controller.toggleDetail,
                ),
                const SizedBox(width: 9),
                PillButton(
                  label: 'Done',
                  expand: false,
                  onPressed: controller.reset,
                ),
              ],
            ),
            if (flow.detailOpen) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.line)),
                ),
                child: const _DetailStat(label: 'Completed', value: 'Just now'),
              ),
              const SizedBox(height: 6),
              const Text(
                'Only this short outcome is saved. Audio and transcripts are discarded.',
                style: TextStyle(color: AppColors.faint, fontSize: 9),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.faint, fontSize: 9)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: AppColors.ink, fontSize: 12)),
      ],
    );
  }
}
