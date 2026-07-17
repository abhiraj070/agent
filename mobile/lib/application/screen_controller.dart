import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppScreen { home, people, activity }

final currentScreenProvider = StateProvider<AppScreen>((ref) => AppScreen.home);
