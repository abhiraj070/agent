import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/orbit_visual.dart';
import '../../../domain/entities/task_phase.dart';

/// Ports the `.execution` block for planning/working phases: assistant
/// reply line, the "intelligence field" orbit animation, and a status
/// line. No longer shows per-person task nodes — `/chat` returns one
/// final text response, not granular per-call status.
class ExecutionView extends StatelessWidget {
  const ExecutionView({
    super.key,
    required this.phase,
    required this.assistantReply,
  });

  final TaskPhase phase;
  final String assistantReply;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          assistantReply,
          style: const TextStyle(
            fontFamily: 'serif',
            color: Color(0xC2ECF1EE),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        OrbitVisual(
          size: 140,
          orbitingDotCount: 3,
          rings: const [
            OrbitRing(sizeFactor: 0.49, opacity: 0.19, rotationSeconds: 12),
            OrbitRing(sizeFactor: 0.76, opacity: 0.29, rotationSeconds: 18, reverse: true),
            OrbitRing(sizeFactor: 1.0, opacity: 0.08, rotationSeconds: 28),
          ],
          center: Container(
            width: 43,
            height: 43,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green.withOpacity(0.045),
              border: Border.all(color: AppColors.green.withOpacity(0.27)),
            ),
            child: const Text('✦', style: TextStyle(color: AppColors.green, fontSize: 15)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.green),
            ),
            const SizedBox(width: 8),
            Text(
              phase == TaskPhase.planning ? 'Understanding your request' : 'Coordinating quietly',
              style: const TextStyle(color: Color(0x9ED6E1DB), fontSize: 9, letterSpacing: 0.4),
            ),
          ],
        ),
        if (phase == TaskPhase.planning) ...[
          const SizedBox(height: 20),
          const _PlanReading(),
        ],
      ],
    );
  }
}

class _PlanReading extends StatelessWidget {
  const _PlanReading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 17,
          height: 17,
          child: CircularProgressIndicator(strokeWidth: 1.4, color: AppColors.green),
        ),
        SizedBox(width: 10),
        Text('Finding the calmest path', style: TextStyle(color: AppColors.muted, fontSize: 10)),
      ],
    );
  }
}
