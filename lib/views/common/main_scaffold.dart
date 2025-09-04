import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enums/navigation_tab.dart';
import '../../viewmodels/navigation/navigation_view_model.dart';
import '../screens/home/home_screen.dart';
import '../screens/metronome/metronome_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_bottom_navigation_widget.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  Widget _getCurrentScreen(NavigationTab currentTab) {
    switch (currentTab) {
      case NavigationTab.home:
        return const HomeScreen();
      case NavigationTab.metronome:
        return const MetronomeScreen();
      case NavigationTab.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navigationProvider);
    final shouldShowHeader = ref.watch(shouldShowHeaderProvider);

    return Scaffold(
      // Show header only when not on metronome screen
      appBar: shouldShowHeader ? const AppHeaderWidget() : null,
      
      // Current screen content
      body: _getCurrentScreen(currentTab),
      
      // Always show bottom navigation
      bottomNavigationBar: const AppBottomNavigationWidget(),
    );
  }
}