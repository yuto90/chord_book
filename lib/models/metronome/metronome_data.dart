import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/metronome_state.dart';

part 'metronome_data.freezed.dart';

@freezed
class MetronomeData with _$MetronomeData {
  const factory MetronomeData({
    @Default(120) int bpm,
    @Default(4) int beatsPerMeasure,
    @Default(MetronomeState.stopped) MetronomeState state,
    @Default(0) int currentBeat,
  }) = _MetronomeData;
}