import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/metronome/metronome_data.dart';
import '../../models/enums/metronome_state.dart';
import '../../services/metronome_service.dart';

class MetronomeNotifier extends StateNotifier<MetronomeData> {
  late final MetronomeService _metronomeService;

  MetronomeNotifier() : super(const MetronomeData()) {
    _metronomeService = MetronomeService();
    _metronomeService.stream.listen((data) {
      state = data;
    });
  }

  void start({int countInMeasures = 0}) {
    _metronomeService.start(state.bpm, state.beatsPerMeasure, 
                           countInMeasures: countInMeasures);
  }

  void stop() {
    _metronomeService.stop();
  }

  void pause() {
    _metronomeService.pause();
  }

  void resume() {
    _metronomeService.resume();
  }

  void setBpm(int bpm) {
    if (bpm >= 30 && bpm <= 300) {
      _metronomeService.setBpm(bpm);
    }
  }

  void setBeatsPerMeasure(int beatsPerMeasure) {
    if (beatsPerMeasure >= 1 && beatsPerMeasure <= 12) {
      _metronomeService.setBeatsPerMeasure(beatsPerMeasure);
    }
  }

  void setAudioEnabled(bool enabled) {
    _metronomeService.setAudioEnabled(enabled);
  }

  void setVisualEnabled(bool enabled) {
    _metronomeService.setVisualEnabled(enabled);
  }

  void setHapticsEnabled(bool enabled) {
    _metronomeService.setHapticsEnabled(enabled);
  }

  void setCountInMeasures(int measures) {
    _metronomeService.setCountInMeasures(measures);
  }

  void togglePlayPause() {
    if (state.state.isPlaying) {
      pause();
    } else if (state.state.isPaused) {
      resume();
    } else {
      start(countInMeasures: state.countInMeasures);
    }
  }

  void tapTempo() {
    _metronomeService.addTapTempo();
  }

  void clearTapTempo() {
    _metronomeService.clearTapTempo();
  }

  void adjustBpm(int delta) {
    setBpm(state.bpm + delta);
  }

  @override
  void dispose() {
    _metronomeService.dispose();
    super.dispose();
  }
}

final metronomeProvider = StateNotifierProvider<MetronomeNotifier, MetronomeData>(
  (ref) => MetronomeNotifier(),
);

// Computed providers for convenience
final metronomeBpmProvider = Provider<int>((ref) {
  return ref.watch(metronomeProvider).bpm;
});

final metronomeBeatsPerMeasureProvider = Provider<int>((ref) {
  return ref.watch(metronomeProvider).beatsPerMeasure;
});

final metronomeStateProvider = Provider<MetronomeState>((ref) {
  return ref.watch(metronomeProvider).state;
});

final metronomeCurrentBeatProvider = Provider<int>((ref) {
  return ref.watch(metronomeProvider).currentBeat;
});

final metronomeAudioEnabledProvider = Provider<bool>((ref) {
  return ref.watch(metronomeProvider).audioEnabled;
});

final metronomeVisualEnabledProvider = Provider<bool>((ref) {
  return ref.watch(metronomeProvider).visualEnabled;
});

final metronomeHapticsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(metronomeProvider).hapticsEnabled;
});

final metronomeCountInProvider = Provider<int>((ref) {
  return ref.watch(metronomeProvider).countInMeasures;
});

final metronomeIsCountingInProvider = Provider<bool>((ref) {
  return ref.watch(metronomeProvider).isInCountIn;
});