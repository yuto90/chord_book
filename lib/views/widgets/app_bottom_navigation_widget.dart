import 'package:flutter/material.dart';
import '../../models/enums/navigation_tab.dart';
import '../../viewmodels/navigation/navigation_view_model.dart';

class AppBottomNavigationWidget extends StatefulWidget {
  final NavigationViewModel navigationViewModel;
  
  const AppBottomNavigationWidget({
    super.key,
    required this.navigationViewModel,
  });

  @override
  State<AppBottomNavigationWidget> createState() => _AppBottomNavigationWidgetState();
}

class _AppBottomNavigationWidgetState extends State<AppBottomNavigationWidget> {
  @override
  void initState() {
    super.initState();
    widget.navigationViewModel.addListener(_onNavigationChanged);
  }

  @override
  void dispose() {
    widget.navigationViewModel.removeListener(_onNavigationChanged);
    super.dispose();
  }

  void _onNavigationChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.navigationViewModel.currentTab.index,
      onTap: (index) {
        final tab = NavigationTab.values[index];
        widget.navigationViewModel.setTab(tab);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      items: NavigationTab.values.map((tab) {
        IconData iconData;
        switch (tab) {
          case NavigationTab.home:
            iconData = Icons.home;
            break;
          case NavigationTab.metronome:
            iconData = Icons.music_note;
            break;
          case NavigationTab.settings:
            iconData = Icons.settings;
            break;
        }

        return BottomNavigationBarItem(
          icon: Icon(iconData),
          label: tab.label,
        );
      }).toList(),
    );
  }
}