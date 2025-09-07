// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_editor_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SongEditorState {
  Song? get currentSong => throw _privateConstructorUsedError;
  bool get isEditing => throw _privateConstructorUsedError;
  bool get hasUnsavedChanges => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongEditorStateCopyWith<SongEditorState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongEditorStateCopyWith<$Res> {
  factory $SongEditorStateCopyWith(
          SongEditorState value, $Res Function(SongEditorState) then) =
      _$SongEditorStateCopyWithImpl<$Res, SongEditorState>;
  @useResult
  $Res call(
      {Song? currentSong,
      bool isEditing,
      bool hasUnsavedChanges,
      String? errorMessage});

  $SongCopyWith<$Res>? get currentSong;
}

/// @nodoc
class _$SongEditorStateCopyWithImpl<$Res, $Val extends SongEditorState>
    implements $SongEditorStateCopyWith<$Res> {
  _$SongEditorStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSong = freezed,
    Object? isEditing = null,
    Object? hasUnsavedChanges = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      currentSong: freezed == currentSong
          ? _value.currentSong
          : currentSong // ignore: cast_nullable_to_non_nullable
              as Song?,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUnsavedChanges: null == hasUnsavedChanges
          ? _value.hasUnsavedChanges
          : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SongCopyWith<$Res>? get currentSong {
    if (_value.currentSong == null) {
      return null;
    }

    return $SongCopyWith<$Res>(_value.currentSong!, (value) {
      return _then(_value.copyWith(currentSong: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SongEditorStateImplCopyWith<$Res>
    implements $SongEditorStateCopyWith<$Res> {
  factory _$$SongEditorStateImplCopyWith(_$SongEditorStateImpl value,
          $Res Function(_$SongEditorStateImpl) then) =
      __$$SongEditorStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Song? currentSong,
      bool isEditing,
      bool hasUnsavedChanges,
      String? errorMessage});

  @override
  $SongCopyWith<$Res>? get currentSong;
}

/// @nodoc
class __$$SongEditorStateImplCopyWithImpl<$Res>
    extends _$SongEditorStateCopyWithImpl<$Res, _$SongEditorStateImpl>
    implements _$$SongEditorStateImplCopyWith<$Res> {
  __$$SongEditorStateImplCopyWithImpl(
      _$SongEditorStateImpl _value, $Res Function(_$SongEditorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentSong = freezed,
    Object? isEditing = null,
    Object? hasUnsavedChanges = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SongEditorStateImpl(
      currentSong: freezed == currentSong
          ? _value.currentSong
          : currentSong // ignore: cast_nullable_to_non_nullable
              as Song?,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUnsavedChanges: null == hasUnsavedChanges
          ? _value.hasUnsavedChanges
          : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SongEditorStateImpl implements _SongEditorState {
  const _$SongEditorStateImpl(
      {this.currentSong,
      this.isEditing = false,
      this.hasUnsavedChanges = false,
      this.errorMessage});

  @override
  final Song? currentSong;
  @override
  @JsonKey()
  final bool isEditing;
  @override
  @JsonKey()
  final bool hasUnsavedChanges;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SongEditorState(currentSong: $currentSong, isEditing: $isEditing, hasUnsavedChanges: $hasUnsavedChanges, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongEditorStateImpl &&
            (identical(other.currentSong, currentSong) ||
                other.currentSong == currentSong) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.hasUnsavedChanges, hasUnsavedChanges) ||
                other.hasUnsavedChanges == hasUnsavedChanges) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, currentSong, isEditing, hasUnsavedChanges, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongEditorStateImplCopyWith<_$SongEditorStateImpl> get copyWith =>
      __$$SongEditorStateImplCopyWithImpl<_$SongEditorStateImpl>(
          this, _then);
}

abstract class _SongEditorState implements SongEditorState {
  const factory _SongEditorState(
      {final Song? currentSong,
      final bool isEditing,
      final bool hasUnsavedChanges,
      final String? errorMessage}) = _$SongEditorStateImpl;

  @override
  Song? get currentSong;
  @override
  bool get isEditing;
  @override
  bool get hasUnsavedChanges;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$SongEditorStateImplCopyWith<_$SongEditorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songEditorViewModelHash() => r'2a1b3c4d5e6f7a8b9c0d1e2f3a4b5c6d';

/// See also [SongEditorViewModel].
@ProviderFor(SongEditorViewModel)
final songEditorViewModelProvider =
    AutoDisposeNotifierProvider<SongEditorViewModel, SongEditorState>.internal(
  SongEditorViewModel.new,
  name: r'songEditorViewModelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$songEditorViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SongEditorViewModel = AutoDisposeNotifier<SongEditorState>;