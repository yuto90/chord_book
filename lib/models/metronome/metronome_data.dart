import '../enums/metronome_state.dart';

class MetronomeData {
  final int bpm;
  final int beatsPerMeasure;
  final MetronomeState state;
  final int currentBeat;

  const MetronomeData({
    this.bpm = 120,
    this.beatsPerMeasure = 4,
    this.state = MetronomeState.stopped,
    this.currentBeat = 0,
  });

  MetronomeData copyWith({
    int? bpm,
    int? beatsPerMeasure,
    MetronomeState? state,
    int? currentBeat,
  }) {
    return MetronomeData(
      bpm: bpm ?? this.bpm,
      beatsPerMeasure: beatsPerMeasure ?? this.beatsPerMeasure,
      state: state ?? this.state,
      currentBeat: currentBeat ?? this.currentBeat,
    );
  }

  @override
  String toString() {
    return 'MetronomeData(bpm: $bpm, beatsPerMeasure: $beatsPerMeasure, state: $state, currentBeat: $currentBeat)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MetronomeData &&
        other.bpm == bpm &&
        other.beatsPerMeasure == beatsPerMeasure &&
        other.state == state &&
        other.currentBeat == currentBeat;
  }

  @override
  int get hashCode {
    return Object.hash(bpm, beatsPerMeasure, state, currentBeat);
  }
}