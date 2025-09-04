enum NavigationTab {
  home,
  metronome,
  settings;

  String get label {
    switch (this) {
      case NavigationTab.home:
        return 'ホーム';
      case NavigationTab.metronome:
        return 'メトロノーム';
      case NavigationTab.settings:
        return '設定';
    }
  }

  String get route {
    switch (this) {
      case NavigationTab.home:
        return '/home';
      case NavigationTab.metronome:
        return '/metronome';
      case NavigationTab.settings:
        return '/settings';
    }
  }
}