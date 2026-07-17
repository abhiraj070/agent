import 'package:flutter/material.dart';

import '../../domain/entities/task_node.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Ports `.task-node`: a two-column card (dot + copy) whose border/fill
/// react to [NodeState], plus a compact "done" variant used once the whole
/// task has completed (`.phase-complete .task-node`).
class TaskNodeCard extends StatelessWidget {
  const TaskNodeCard({
    super.key,
    required this.node,
    required this.index,
    this.compact = false,
    this.onTap,
  });

  final TaskNode node;
  final int index;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCalling = node.state == NodeState.calling;
    final isDone = node.state == NodeState.done;

    final borderColor = isCalling
        ? AppColors.green.withOpacity(0.22)
        : Colors.white.withOpacity(compact ? 0.045 : 0.075);
    final fillColor =
        isCalling ? AppColors.green.withOpacity(0.06) : Colors.white.withOpacity(0.02);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 11 : AppRadius.chip + 4),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 10,
            vertical: compact ? 6 : 9,
          ),
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(compact ? 11 : AppRadius.chip + 4),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _NodeDot(node: node, index: index, compact: compact, isDone: isDone, isCalling: isCalling),
              SizedBox(width: compact ? 7 : 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      node.person,
                      style: TextStyle(
                        color: compact ? AppColors.ink.withOpacity(0.72) : AppColors.ink,
                        fontWeight: compact ? FontWeight.w400 : FontWeight.w600,
                        fontSize: compact ? 9 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 4),
                      Text(
                        node.action,
                        style: const TextStyle(color: AppColors.muted, fontSize: 9),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (!compact)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    node.state.label.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.faint,
                      fontSize: 6,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NodeDot extends StatelessWidget {
  const _NodeDot({
    required this.node,
    required this.index,
    required this.compact,
    required this.isDone,
    required this.isCalling,
  });

  final TaskNode node;
  final int index;
  final bool compact;
  final bool isDone;
  final bool isCalling;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 20.0 : 29.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone
            ? (compact ? AppColors.green.withOpacity(0.3) : AppColors.green.withOpacity(0.9))
            : Colors.transparent,
        border: Border.all(
          color: isDone
              ? Colors.transparent
              : (isCalling ? AppColors.green.withOpacity(0.31) : Colors.white.withOpacity(0.09)),
        ),
      ),
      child: Text(
        isDone ? '✓' : '${index + 1}',
        style: TextStyle(
          fontSize: compact ? 7 : 9,
          color: isDone
              ? (compact ? AppColors.ink.withOpacity(0.72) : const Color(0xFF102018))
              : (isCalling ? AppColors.green : AppColors.muted),
        ),
      ),
    );
  }
}
