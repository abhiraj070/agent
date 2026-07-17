import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/orbit_visual.dart';
import '../../../core/widgets/task_node_card.dart';
import '../../../domain/entities/task_node.dart';
import '../../../domain/entities/task_phase.dart';

/// Ports the `.execution` block for planning/working phases: assistant
/// reply line, the "intelligence field" orbit animation, a status line, and
/// the grid of [TaskNodeCard]s.
class ExecutionView extends StatelessWidget {
  const ExecutionView({
    super.key,
    required this.phase,
    required this.assistantReply,
    required this.nodes,
    required this.activeNode,
    required this.onNodeTap,
  });

  final TaskPhase phase;
  final String assistantReply;
  final List<TaskNode> nodes;
  final TaskNode? activeNode;
  final VoidCallback onNodeTap;

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
        const SizedBox(height: 4),
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
              phase == TaskPhase.planning
                  ? 'Understanding your request'
                  : activeNode != null
                      ? 'Coordinating with ${activeNode!.person}'
                      : 'Coordinating quietly',
              style: const TextStyle(color: Color(0x9ED6E1DB), fontSize: 9, letterSpacing: 0.4),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (phase == TaskPhase.planning)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: _PlanReading(),
          )
        else
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.7,
            children: [
              for (var i = 0; i < nodes.length; i++)
                TaskNodeCard(node: nodes[i], index: i, onTap: onNodeTap),
            ],
          ),
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
