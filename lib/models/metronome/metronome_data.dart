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
    // 出力設定
    @Default(true) bool audioEnabled,
    @Default(true) bool visualEnabled,
    @Default(true) bool hapticsEnabled,
    // カウントイン設定
    @Default(0) int countInMeasures, // 0 = off, 1-4 = count-in measures
    @Default(false) bool isCountingIn,
    @Default(0) int countInBeat,
    // タップテンポ用（削除予定だが、freezed互換性のため一時的に保持）
    @Default(<int>[]) List<int> tapTimestamps,
    // 時間表記設定（将来的な拡張用）
    @Default(4) int timeSignatureNumerator,
    @Default(4) int timeSignatureDenominator,
  }) = _MetronomeData;
  
  const MetronomeData._();
  
  /// 強拍かどうかを判定
  bool get isStrongBeat {
    if (currentBeat == 0) return false;
    // 一般的に、1拍目は強拍
    return currentBeat == 1;
  }
  
  /// カウントイン中かどうか
  bool get isInCountIn => isCountingIn && countInMeasures > 0;
}