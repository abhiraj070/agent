import '../../domain/entities/onboarding_example.dart';

/// Static seed content. `onboardingExamples` is part of the onboarding
/// pitch itself (explicitly illustrative, shown before any real account
/// exists) — everything else the app displays now comes from real local
/// or backend data.
class SeedData {
  const SeedData._();

  static const List<OnboardingExample> onboardingExamples = [
    OnboardingExample(request: 'Ask my driver to meet me at the gate in five minutes.', source: 'Driver replied', result: '“I’ll be at Gate 2.”', initials: 'DR'),
    OnboardingExample(request: 'Find out what time the househelp is coming today.', source: 'Househelp replied', result: '“I’ll come around 6 pm.”', initials: 'HH'),
    OnboardingExample(request: 'Coordinate dinner so everything is ready by eight.', source: 'Dinner coordinated', result: 'Groceries by 6:15. Dinner by 8.', initials: '✓'),
    OnboardingExample(request: 'Ask maintenance for an electrician on Sunday afternoon.', source: 'Maintenance confirmed', result: 'Electrician booked for Sunday, 3 pm.', initials: 'MO'),
  ];

  /// Matches the backend's Role enum (agent/db/model/user.py) exactly so
  /// every role picked here round-trips through `POST /add_members`.
  static const List<String> personRoles = [
    'Driver',
    'Cook',
    'Maid',
    'Nanny',
    'Gardner',
    'Dog Walker',
    'House Manager',
    'Maintenance',
    'Security',
    'Other',
  ];

  static const List<String> languages = [
    'Hindi',
    'English',
    'Hinglish',
    'Punjabi',
    'Bengali',
    'Tamil',
    'Marathi',
  ];
}
