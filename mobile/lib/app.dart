import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/app_stage_controller.dart';
import 'application/chat_socket_controller.dart';
import 'application/people_controller.dart';
import 'application/screen_controller.dart';
import 'application/task_flow_controller.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'domain/entities/person.dart';
import 'presentation/activity/activity_screen.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/onboarding/onboarding_screen.dart';
import 'presentation/people/people_screen.dart';
import 'presentation/splash/splash_screen.dart';

class AaraamApp extends StatelessWidget {
  const AaraamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aaraam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const _AppRoot(),
    );
  }
}

/// Routes between the three top-level stages the mockup's `onboardingStep`
/// state machine encodes: splash, onboarding, and the main app.
class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = ref.watch(appStageControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backdrop,
      body: switch (stage) {
        AppStage.splash => const SplashScreen(),
        AppStage.onboarding => const OnboardingScreen(),
        AppStage.main => const _MainShell(),
      },
    );
  }
}

/// Persistent top bar (brand + My People shortcut) with the home/people/
/// activity body swapping beneath it — ports the always-visible `.topbar`
/// from UI_design/app/page.tsx, which stays mounted across those three
/// screens while only the body below it changes.
///
/// Also where the `/ws` connection for `/chat` gets established: watching
/// [chatSocketControllerProvider] here creates it the moment the user
/// reaches this screen (after login/signup) and keeps it alive for as
/// long as `_MainShell` stays mounted, i.e. the rest of the session.
class _MainShell extends ConsumerWidget {
  const _MainShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatSocketControllerProvider);
    final screen = ref.watch(currentScreenProvider);
    final people = ref.watch(peopleControllerProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.stageBackground),
      child: SafeArea(
        child: Column(
          children: [
            _TopBar(
              people: people,
              onBrandTap: () {
                ref.read(currentScreenProvider.notifier).state = AppScreen.home;
                ref.read(taskFlowControllerProvider.notifier).reset();
              },
              onPeopleTap: () {
                ref.read(currentScreenProvider.notifier).state = AppScreen.people;
              },
            ),
            Expanded(
              child: switch (screen) {
                AppScreen.home => const HomeScreen(),
                AppScreen.people => const PeopleScreen(),
                AppScreen.activity => const ActivityScreen(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.people,
    required this.onBrandTap,
    required this.onPeopleTap,
  });

  final List<Person> people;
  final VoidCallback onBrandTap;
  final VoidCallback onPeopleTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBrandTap,
            borderRadius: BorderRadius.circular(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 29,
                  height: 29,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.soft,
                    border: Border.all(color: AppColors.green.withOpacity(0.28)),
                  ),
                  child: const Text('अ', style: TextStyle(color: AppColors.green, fontSize: 14)),
                ),
                const SizedBox(width: 9),
                const Text(
                  'Aaraam',
                  style: TextStyle(color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          _PeopleAvatarStack(people: people, onTap: onPeopleTap),
        ],
      ),
    );
  }
}

/// Ports `.avatar-stack`: up to two initials chips plus a "+N" overflow
/// chip, overlapping in a row.
class _PeopleAvatarStack extends StatelessWidget {
  const _PeopleAvatarStack({required this.people, required this.onTap});

  final List<Person> people;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shown = people.take(2).toList();
    final chips = <Widget>[
      for (final person in shown) _AvatarChip(label: person.initials),
      if (people.length > shown.length)
        _AvatarChip(label: '+${people.length - shown.length}', accent: true),
    ];
    final width = chips.isEmpty ? 27.0 : 19.0 * (chips.length - 1) + 27.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 27,
          width: width,
          child: Stack(
            children: [
              for (var i = 0; i < chips.length; i++)
                Positioned(left: i * 19.0, child: chips[i]),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarChip extends StatelessWidget {
  const _AvatarChip({required this.label, this.accent = false});

  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 27,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent ? const Color(0xFF3B4B43) : const Color(0xFF242B28),
        border: Border.all(color: AppColors.surface, width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: accent ? AppColors.green : const Color(0xFFCCD2CF),
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
