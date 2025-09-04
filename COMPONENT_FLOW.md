# Component Flow Documentation

## App Structure Flow

```
main.dart (ChordBookApp)
    └── MainScaffold
        ├── AppHeaderWidget (conditional - hidden on metronome screen)
        │   ├── MetronomeViewModel (shared)
        │   └── Compact controls (BPM, play/pause, beat indicator)
        │
        ├── Current Screen (based on NavigationViewModel.currentTab)
        │   ├── HomeScreen (shows header + footer)
        │   ├── MetronomeScreen (no header + footer)
        │   │   └── MetronomeViewModel (shared with header)
        │   └── SettingsScreen (shows header + footer)
        │
        └── AppBottomNavigationWidget (always visible)
            └── NavigationViewModel
```

## State Management Flow

```
NavigationViewModel
    ├── currentTab (NavigationTab enum)
    ├── shouldShowHeader (computed property)
    └── setTab(NavigationTab) (triggers UI rebuild)

MetronomeViewModel
    ├── MetronomeService (timing logic)
    ├── MetronomeData (bpm, state, currentBeat)
    └── Control methods (start/stop/pause/setBpm)
```

## Screen Visibility Rules

| Screen    | Header | Footer | Metronome in Header |
|-----------|--------|--------|-------------------|
| Home      | ✅     | ✅     | ✅                |
| Metronome | ❌     | ✅     | ❌ (full screen)  |
| Settings  | ✅     | ✅     | ✅                |

## Navigation Flow

```
User taps footer tab
    ↓
NavigationViewModel.setTab()
    ↓
MainScaffold rebuilds
    ├── Updates current screen
    ├── Shows/hides header based on screen
    └── Footer always visible
```

## Metronome Synchronization

```
Shared MetronomeViewModel instance
    ├── Header controls (compact UI)
    └── Full screen (detailed UI)
    
Both interfaces control same state:
    ├── BPM adjustments
    ├── Play/Pause/Stop
    └── Beat visualization
```