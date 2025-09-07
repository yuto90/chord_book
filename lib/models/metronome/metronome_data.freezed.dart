// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metronome_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MetronomeData {
  int get bpm => throw _privateConstructorUsedError;
  int get beatsPerMeasure => throw _privateConstructorUsedError;
  MetronomeState get state => throw _privateConstructorUsedError;
  int get currentBeat => throw _privateConstructorUsedError; // 出力設定
  bool get audioEnabled => throw _privateConstructorUsedError;
  bool get visualEnabled => throw _privateConstructorUsedError;
  bool get hapticsEnabled => throw _privateConstructorUsedError; // カウントイン設定
  int get countInMeasures =>
      throw _privateConstructorUsedError; // 0 = off, 1-4 = count-in measures
  bool get isCountingIn => throw _privateConstructorUsedError;
  int get countInBeat => throw _privateConstructorUsedError; // タップテンポ用
  List<int> get tapTimestamps =>
      throw _privateConstructorUsedError; // 時間表記設定（将来的な拡張用）
  int get timeSignatureNumerator => throw _privateConstructorUsedError;
  int get timeSignatureDenominator => throw _privateConstructorUsedError;

  /// Create a copy of MetronomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetronomeDataCopyWith<MetronomeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetronomeDataCopyWith<$Res> {
  factory $MetronomeDataCopyWith(
          MetronomeData value, $Res Function(MetronomeData) then) =
      _$MetronomeDataCopyWithImpl<$Res, MetronomeData>;
  @useResult
  $Res call(
      {int bpm,
      int beatsPerMeasure,
      MetronomeState state,
      int currentBeat,
      bool audioEnabled,
      bool visualEnabled,
      bool hapticsEnabled,
      int countInMeasures,
      bool isCountingIn,
      int countInBeat,
      List<int> tapTimestamps,
      int timeSignatureNumerator,
      int timeSignatureDenominator});
}

/// @nodoc
class _$MetronomeDataCopyWithImpl<$Res, $Val extends MetronomeData>
    implements $MetronomeDataCopyWith<$Res> {
  _$MetronomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetronomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bpm = null,
    Object? beatsPerMeasure = null,
    Object? state = null,
    Object? currentBeat = null,
    Object? audioEnabled = null,
    Object? visualEnabled = null,
    Object? hapticsEnabled = null,
    Object? countInMeasures = null,
    Object? isCountingIn = null,
    Object? countInBeat = null,
    Object? tapTimestamps = null,
    Object? timeSignatureNumerator = null,
    Object? timeSignatureDenominator = null,
  }) {
    return _then(_value.copyWith(
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int,
      beatsPerMeasure: null == beatsPerMeasure
          ? _value.beatsPerMeasure
          : beatsPerMeasure // ignore: cast_nullable_to_non_nullable
              as int,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as MetronomeState,
      currentBeat: null == currentBeat
          ? _value.currentBeat
          : currentBeat // ignore: cast_nullable_to_non_nullable
              as int,
      audioEnabled: null == audioEnabled
          ? _value.audioEnabled
          : audioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      visualEnabled: null == visualEnabled
          ? _value.visualEnabled
          : visualEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hapticsEnabled: null == hapticsEnabled
          ? _value.hapticsEnabled
          : hapticsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countInMeasures: null == countInMeasures
          ? _value.countInMeasures
          : countInMeasures // ignore: cast_nullable_to_non_nullable
              as int,
      isCountingIn: null == isCountingIn
          ? _value.isCountingIn
          : isCountingIn // ignore: cast_nullable_to_non_nullable
              as bool,
      countInBeat: null == countInBeat
          ? _value.countInBeat
          : countInBeat // ignore: cast_nullable_to_non_nullable
              as int,
      tapTimestamps: null == tapTimestamps
          ? _value.tapTimestamps
          : tapTimestamps // ignore: cast_nullable_to_non_nullable
              as List<int>,
      timeSignatureNumerator: null == timeSignatureNumerator
          ? _value.timeSignatureNumerator
          : timeSignatureNumerator // ignore: cast_nullable_to_non_nullable
              as int,
      timeSignatureDenominator: null == timeSignatureDenominator
          ? _value.timeSignatureDenominator
          : timeSignatureDenominator // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetronomeDataImplCopyWith<$Res>
    implements $MetronomeDataCopyWith<$Res> {
  factory _$$MetronomeDataImplCopyWith(
          _$MetronomeDataImpl value, $Res Function(_$MetronomeDataImpl) then) =
      __$$MetronomeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int bpm,
      int beatsPerMeasure,
      MetronomeState state,
      int currentBeat,
      bool audioEnabled,
      bool visualEnabled,
      bool hapticsEnabled,
      int countInMeasures,
      bool isCountingIn,
      int countInBeat,
      List<int> tapTimestamps,
      int timeSignatureNumerator,
      int timeSignatureDenominator});
}

/// @nodoc
class __$$MetronomeDataImplCopyWithImpl<$Res>
    extends _$MetronomeDataCopyWithImpl<$Res, _$MetronomeDataImpl>
    implements _$$MetronomeDataImplCopyWith<$Res> {
  __$$MetronomeDataImplCopyWithImpl(
      _$MetronomeDataImpl _value, $Res Function(_$MetronomeDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MetronomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bpm = null,
    Object? beatsPerMeasure = null,
    Object? state = null,
    Object? currentBeat = null,
    Object? audioEnabled = null,
    Object? visualEnabled = null,
    Object? hapticsEnabled = null,
    Object? countInMeasures = null,
    Object? isCountingIn = null,
    Object? countInBeat = null,
    Object? tapTimestamps = null,
    Object? timeSignatureNumerator = null,
    Object? timeSignatureDenominator = null,
  }) {
    return _then(_$MetronomeDataImpl(
      bpm: null == bpm
          ? _value.bpm
          : bpm // ignore: cast_nullable_to_non_nullable
              as int,
      beatsPerMeasure: null == beatsPerMeasure
          ? _value.beatsPerMeasure
          : beatsPerMeasure // ignore: cast_nullable_to_non_nullable
              as int,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as MetronomeState,
      currentBeat: null == currentBeat
          ? _value.currentBeat
          : currentBeat // ignore: cast_nullable_to_non_nullable
              as int,
      audioEnabled: null == audioEnabled
          ? _value.audioEnabled
          : audioEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      visualEnabled: null == visualEnabled
          ? _value.visualEnabled
          : visualEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hapticsEnabled: null == hapticsEnabled
          ? _value.hapticsEnabled
          : hapticsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      countInMeasures: null == countInMeasures
          ? _value.countInMeasures
          : countInMeasures // ignore: cast_nullable_to_non_nullable
              as int,
      isCountingIn: null == isCountingIn
          ? _value.isCountingIn
          : isCountingIn // ignore: cast_nullable_to_non_nullable
              as bool,
      countInBeat: null == countInBeat
          ? _value.countInBeat
          : countInBeat // ignore: cast_nullable_to_non_nullable
              as int,
      tapTimestamps: null == tapTimestamps
          ? _value._tapTimestamps
          : tapTimestamps // ignore: cast_nullable_to_non_nullable
              as List<int>,
      timeSignatureNumerator: null == timeSignatureNumerator
          ? _value.timeSignatureNumerator
          : timeSignatureNumerator // ignore: cast_nullable_to_non_nullable
              as int,
      timeSignatureDenominator: null == timeSignatureDenominator
          ? _value.timeSignatureDenominator
          : timeSignatureDenominator // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MetronomeDataImpl extends _MetronomeData {
  const _$MetronomeDataImpl(
      {this.bpm = 120,
      this.beatsPerMeasure = 4,
      this.state = MetronomeState.stopped,
      this.currentBeat = 0,
      this.audioEnabled = true,
      this.visualEnabled = true,
      this.hapticsEnabled = true,
      this.countInMeasures = 0,
      this.isCountingIn = false,
      this.countInBeat = 0,
      final List<int> tapTimestamps = const <int>[],
      this.timeSignatureNumerator = 4,
      this.timeSignatureDenominator = 4})
      : _tapTimestamps = tapTimestamps,
        super._();

  @override
  @JsonKey()
  final int bpm;
  @override
  @JsonKey()
  final int beatsPerMeasure;
  @override
  @JsonKey()
  final MetronomeState state;
  @override
  @JsonKey()
  final int currentBeat;
// 出力設定
  @override
  @JsonKey()
  final bool audioEnabled;
  @override
  @JsonKey()
  final bool visualEnabled;
  @override
  @JsonKey()
  final bool hapticsEnabled;
// カウントイン設定
  @override
  @JsonKey()
  final int countInMeasures;
// 0 = off, 1-4 = count-in measures
  @override
  @JsonKey()
  final bool isCountingIn;
  @override
  @JsonKey()
  final int countInBeat;
// タップテンポ用
  final List<int> _tapTimestamps;
// タップテンポ用
  @override
  @JsonKey()
  List<int> get tapTimestamps {
    if (_tapTimestamps is EqualUnmodifiableListView) return _tapTimestamps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tapTimestamps);
  }

// 時間表記設定（将来的な拡張用）
  @override
  @JsonKey()
  final int timeSignatureNumerator;
  @override
  @JsonKey()
  final int timeSignatureDenominator;

  @override
  String toString() {
    return 'MetronomeData(bpm: $bpm, beatsPerMeasure: $beatsPerMeasure, state: $state, currentBeat: $currentBeat, audioEnabled: $audioEnabled, visualEnabled: $visualEnabled, hapticsEnabled: $hapticsEnabled, countInMeasures: $countInMeasures, isCountingIn: $isCountingIn, countInBeat: $countInBeat, tapTimestamps: $tapTimestamps, timeSignatureNumerator: $timeSignatureNumerator, timeSignatureDenominator: $timeSignatureDenominator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetronomeDataImpl &&
            (identical(other.bpm, bpm) || other.bpm == bpm) &&
            (identical(other.beatsPerMeasure, beatsPerMeasure) ||
                other.beatsPerMeasure == beatsPerMeasure) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.currentBeat, currentBeat) ||
                other.currentBeat == currentBeat) &&
            (identical(other.audioEnabled, audioEnabled) ||
                other.audioEnabled == audioEnabled) &&
            (identical(other.visualEnabled, visualEnabled) ||
                other.visualEnabled == visualEnabled) &&
            (identical(other.hapticsEnabled, hapticsEnabled) ||
                other.hapticsEnabled == hapticsEnabled) &&
            (identical(other.countInMeasures, countInMeasures) ||
                other.countInMeasures == countInMeasures) &&
            (identical(other.isCountingIn, isCountingIn) ||
                other.isCountingIn == isCountingIn) &&
            (identical(other.countInBeat, countInBeat) ||
                other.countInBeat == countInBeat) &&
            const DeepCollectionEquality()
                .equals(other._tapTimestamps, _tapTimestamps) &&
            (identical(other.timeSignatureNumerator, timeSignatureNumerator) ||
                other.timeSignatureNumerator == timeSignatureNumerator) &&
            (identical(
                    other.timeSignatureDenominator, timeSignatureDenominator) ||
                other.timeSignatureDenominator == timeSignatureDenominator));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      bpm,
      beatsPerMeasure,
      state,
      currentBeat,
      audioEnabled,
      visualEnabled,
      hapticsEnabled,
      countInMeasures,
      isCountingIn,
      countInBeat,
      const DeepCollectionEquality().hash(_tapTimestamps),
      timeSignatureNumerator,
      timeSignatureDenominator);

  /// Create a copy of MetronomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetronomeDataImplCopyWith<_$MetronomeDataImpl> get copyWith =>
      __$$MetronomeDataImplCopyWithImpl<_$MetronomeDataImpl>(this, _$identity);
}

abstract class _MetronomeData extends MetronomeData {
  const factory _MetronomeData(
      {final int bpm,
      final int beatsPerMeasure,
      final MetronomeState state,
      final int currentBeat,
      final bool audioEnabled,
      final bool visualEnabled,
      final bool hapticsEnabled,
      final int countInMeasures,
      final bool isCountingIn,
      final int countInBeat,
      final List<int> tapTimestamps,
      final int timeSignatureNumerator,
      final int timeSignatureDenominator}) = _$MetronomeDataImpl;
  const _MetronomeData._() : super._();

  @override
  int get bpm;
  @override
  int get beatsPerMeasure;
  @override
  MetronomeState get state;
  @override
  int get currentBeat; // 出力設定
  @override
  bool get audioEnabled;
  @override
  bool get visualEnabled;
  @override
  bool get hapticsEnabled; // カウントイン設定
  @override
  int get countInMeasures; // 0 = off, 1-4 = count-in measures
  @override
  bool get isCountingIn;
  @override
  int get countInBeat; // タップテンポ用
  @override
  List<int> get tapTimestamps; // 時間表記設定（将来的な拡張用）
  @override
  int get timeSignatureNumerator;
  @override
  int get timeSignatureDenominator;

  /// Create a copy of MetronomeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetronomeDataImplCopyWith<_$MetronomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
