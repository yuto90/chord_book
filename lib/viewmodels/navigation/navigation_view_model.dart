import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enums/navigation_tab.dart';

class NavigationNotifier extends StateNotifier<NavigationTab> {
  NavigationNotifier() : super(NavigationTab.home);

  void setTab(NavigationTab tab) {
    if (state != tab) {
      state = tab;
    }
  }

  bool get isMetronomeScreen => state == NavigationTab.metronome;
  bool get shouldShowHeader => !isMetronomeScreen;
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationTab>(
  (ref) => NavigationNotifier(),
);

// Computed providers for convenience
final isMetronomeScreenProvider = Provider<bool>((ref) {
  final currentTab = ref.watch(navigationProvider);
  return currentTab == NavigationTab.metronome;
});

final shouldShowHeaderProvider = Provider<bool>((ref) {
  final currentTab = ref.watch(navigationProvider);
  return currentTab != NavigationTab.metronome;
});