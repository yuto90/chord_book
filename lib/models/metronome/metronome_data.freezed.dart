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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MetronomeData {
  int get bpm => throw _privateConstructorUsedError;
  int get beatsPerMeasure => throw _privateConstructorUsedError;
  MetronomeState get state => throw _privateConstructorUsedError;
  int get currentBeat => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      {int bpm, int beatsPerMeasure, MetronomeState state, int currentBeat});
}

/// @nodoc
class _$MetronomeDataCopyWithImpl<$Res, $Val extends MetronomeData>
    implements $MetronomeDataCopyWith<$Res> {
  _$MetronomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bpm = null,
    Object? beatsPerMeasure = null,
    Object? state = null,
    Object? currentBeat = null,
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
      {int bpm, int beatsPerMeasure, MetronomeState state, int currentBeat});
}

/// @nodoc
class __$$MetronomeDataImplCopyWithImpl<$Res>
    extends _$MetronomeDataCopyWithImpl<$Res, _$MetronomeDataImpl>
    implements _$$MetronomeDataImplCopyWith<$Res> {
  __$$MetronomeDataImplCopyWithImpl(
      _$MetronomeDataImpl _value, $Res Function(_$MetronomeDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bpm = null,
    Object? beatsPerMeasure = null,
    Object? state = null,
    Object? currentBeat = null,
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
    ));
  }
}

/// @nodoc

class _$MetronomeDataImpl implements _MetronomeData {
  const _$MetronomeDataImpl(
      {this.bpm = 120,
      this.beatsPerMeasure = 4,
      this.state = MetronomeState.stopped,
      this.currentBeat = 0});

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

  @override
  String toString() {
    return 'MetronomeData(bpm: $bpm, beatsPerMeasure: $beatsPerMeasure, state: $state, currentBeat: $currentBeat)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetronomeDataImpl &&
            (identical(other.bpm, bpm) || other.bpm == bpm) &&
            (identical(other.beatsPerMeasure, beatsPerMeasure) ||
                other.beatsPerMeasure == beatsPerMeasure) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.currentBeat, currentBeat) ||
                other.currentBeat == currentBeat));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, bpm, beatsPerMeasure, state, currentBeat);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetronomeDataImplCopyWith<_$MetronomeDataImpl> get copyWith =>
      __$$MetronomeDataImplCopyWithImpl<_$MetronomeDataImpl>(this, _$identity);
}

abstract class _MetronomeData implements MetronomeData {
  const factory _MetronomeData(
      {final int bpm,
      final int beatsPerMeasure,
      final MetronomeState state,
      final int currentBeat}) = _$MetronomeDataImpl;

  @override
  int get bpm;
  @override
  int get beatsPerMeasure;
  @override
  MetronomeState get state;
  @override
  int get currentBeat;
  @override
  @JsonKey(ignore: true)
  _$$MetronomeDataImplCopyWith<_$MetronomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}