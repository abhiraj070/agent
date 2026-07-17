import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_button.dart';

/// Ports `.listening-zone`/`.waveform`: an animated bar waveform plus a
/// "Done speaking" ghost button.
class ListeningView extends StatefulWidget {
  const ListeningView({super.key, required this.onDoneSpeaking});

  final VoidCallback onDoneSpeaking;

  @override
  State<ListeningView> createState() => _ListeningViewState();
}

class _ListeningViewState extends State<ListeningView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 78,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(22, (i) {
                  final base = i % 5 == 0
                      ? 43.0
                      : i % 4 == 0
                          ? 19.0
                          : i % 3 == 0
                              ? 28.0
                              : 12.0;
                  final phase = (_controller.value + i * 0.08) % 1.0;
                  final scale = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(phase * math.pi));
                  return Container(
                    width: 2,
                    height: base * scale,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.78),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        PillButton(
          label: 'Done speaking',
          variant: PillButtonVariant.ghost,
          expand: false,
          onPressed: widget.onDoneSpeaking,
        ),
      ],
    );
  }
}
