import 'package:flutter/material.dart';
import '../../models/enums/navigation_tab.dart';
import '../../viewmodels/navigation/navigation_view_model.dart';
import '../../viewmodels/metronome/metronome_view_model.dart';
import '../screens/home/home_screen.dart';
import '../screens/metronome/metronome_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_bottom_navigation_widget.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late NavigationViewModel _navigationViewModel;
  late MetronomeViewModel _metronomeViewModel;

  @override
  void initState() {
    super.initState();
    _navigationViewModel = NavigationViewModel();
    _metronomeViewModel = MetronomeViewModel();
    _navigationViewModel.addListener(_onNavigationChanged);
  }

  @override
  void dispose() {
    _navigationViewModel.removeListener(_onNavigationChanged);
    _navigationViewModel.dispose();
    _metronomeViewModel.dispose();
    super.dispose();
  }

  void _onNavigationChanged() {
    setState(() {});
  }

  Widget _getCurrentScreen() {
    switch (_navigationViewModel.currentTab) {
      case NavigationTab.home:
        return const HomeScreen();
      case NavigationTab.metronome:
        return MetronomeScreen(metronomeViewModel: _metronomeViewModel);
      case NavigationTab.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show header only when not on metronome screen
      appBar: _navigationViewModel.shouldShowHeader
          ? AppHeaderWidget(metronomeViewModel: _metronomeViewModel)
          : null,
      
      // Current screen content
      body: _getCurrentScreen(),
      
      // Always show bottom navigation
      bottomNavigationBar: AppBottomNavigationWidget(
        navigationViewModel: _navigationViewModel,
      ),
    );
  }
}