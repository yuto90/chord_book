import 'package:flutter/foundation.dart';
import '../../models/enums/navigation_tab.dart';

class NavigationViewModel extends ChangeNotifier {
  NavigationTab _currentTab = NavigationTab.home;
  
  NavigationTab get currentTab => _currentTab;

  void setTab(NavigationTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  bool get isMetronomeScreen => _currentTab == NavigationTab.metronome;
  bool get shouldShowHeader => !isMetronomeScreen;
}