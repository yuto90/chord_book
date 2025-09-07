// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$songListViewModelHash() => r'5f8c4e8d4f7c6b9a0123456789abcdef';

/// See also [SongListViewModel].
@ProviderFor(SongListViewModel)
final songListViewModelProvider =
    AutoDisposeAsyncNotifierProvider<SongListViewModel, List<Song>>.internal(
  SongListViewModel.new,
  name: r'songListViewModelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$songListViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SongListViewModel = AutoDisposeAsyncNotifier<List<Song>>;