/// Shared radii, gaps and motion durations used across the app.
class AppRadius {
  const AppRadius._();

  static const double pill = 999;
  static const double card = 19;
  static const double sheet = 24;
  static const double button = 15;
  static const double chip = 11;
}

class AppSpacing {
  const AppSpacing._();

  static const double screenPadding = 24;
  static const double gapSmall = 8;
  static const double gapMedium = 16;
  static const double gapLarge = 24;
}

class AppDurations {
  const AppDurations._();

  static const Duration voiceListenFirstLine = Duration(milliseconds: 900);
  static const Duration voiceListenSecondLine = Duration(milliseconds: 1950);
  static const Duration voiceListenToPlanning = Duration(milliseconds: 3100);
  static const Duration planningStep = Duration(milliseconds: 650);

  static const Duration orbitSlow = Duration(seconds: 18);
  static const Duration orbitMedium = Duration(seconds: 12);
  static const Duration breathe = Duration(seconds: 7);
  static const Duration toast = Duration(milliseconds: 2600);
}
