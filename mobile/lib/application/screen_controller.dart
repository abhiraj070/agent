import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppScreen { home, people, activity }

final currentScreenProvider = StateProvider<AppScreen>((ref) => AppScreen.home);

/// The Activity screen's own list/detail sub-state: null shows the list,
/// a non-null id shows that entry's detail view. Local to the Activity
/// feature — resets whenever it's cleared on the way back to Home.
final selectedActivityIdProvider = StateProvider<int?>((ref) => null);
