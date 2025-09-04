import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enums/navigation_tab.dart';
import '../../viewmodels/navigation/navigation_view_model.dart';

class AppBottomNavigationWidget extends ConsumerWidget {
  const AppBottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navigationProvider);
    
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap: (index) {
        final tab = NavigationTab.values[index];
        ref.read(navigationProvider.notifier).setTab(tab);
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