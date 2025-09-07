import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/song/song.dart';
import '../../models/song/lyric_line.dart';
import '../../models/song/chord_block.dart';

part 'song_editor_viewmodel.g.dart';
part 'song_editor_viewmodel.freezed.dart';

@freezed
class SongEditorState with _$SongEditorState {
  const factory SongEditorState({
    Song? currentSong,
    @Default(false) bool isEditing,
    @Default(false) bool hasUnsavedChanges,
    String? errorMessage,
  }) = _SongEditorState;
}

@riverpod 
class SongEditorViewModel extends _$SongEditorViewModel {
  @override
  SongEditorState build() {
    return const SongEditorState();
  }

  void loadSong(Song song) {
    state = state.copyWith(
      currentSong: song,
      isEditing: false,
      hasUnsavedChanges: false,
    );
  }

  void startEditing() {
    state = state.copyWith(isEditing: true);
  }

  void stopEditing() {
    state = state.copyWith(isEditing: false);
  }

  void updateTitle(String title) {
    if (state.currentSong != null) {
      final updatedSong = state.currentSong!.copyWith(
        title: title,
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(
        currentSong: updatedSong,
        hasUnsavedChanges: true,
      );
    }
  }

  void updateArtist(String artist) {
    if (state.currentSong != null) {
      final updatedSong = state.currentSong!.copyWith(
        artist: artist,
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(
        currentSong: updatedSong,
        hasUnsavedChanges: true,
      );
    }
  }

  void addLyricLine(String text) {
    if (state.currentSong != null) {
      final newLine = LyricLine(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        order: state.currentSong!.lyricLines.length,
      );
      
      final updatedSong = state.currentSong!.copyWith(
        lyricLines: [...state.currentSong!.lyricLines, newLine],
        updatedAt: DateTime.now(),
      );
      
      state = state.copyWith(
        currentSong: updatedSong,
        hasUnsavedChanges: true,
      );
    }
  }

  void updateLyricLine(String lineId, String text) {
    if (state.currentSong != null) {
      final updatedLines = state.currentSong!.lyricLines.map((line) {
        if (line.id == lineId) {
          return line.copyWith(text: text);
        }
        return line;
      }).toList();

      final updatedSong = state.currentSong!.copyWith(
        lyricLines: updatedLines,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        currentSong: updatedSong,
        hasUnsavedChanges: true,
      );
    }
  }

  void addChordToLine(String lineId, ChordBlock chordBlock) {
    if (state.currentSong != null) {
      final updatedLines = state.currentSong!.lyricLines.map((line) {
        if (line.id == lineId) {
          return line.copyWith(
            chordBlocks: [...line.chordBlocks, chordBlock],
          );
        }
        return line;
      }).toList();

      final updatedSong = state.currentSong!.copyWith(
        lyricLines: updatedLines,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        currentSong: updatedSong,
        hasUnsavedChanges: true,
      );
    }
  }

  Future<void> saveSong() async {
    if (state.currentSong == null) return;

    try {
      // Here we would save to a repository
      // For now, just mark as saved
      state = state.copyWith(
        hasUnsavedChanges: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to save song: $e',
      );
    }
  }

  Song? createNewSong() {
    final now = DateTime.now();
    final newSong = Song(
      id: now.millisecondsSinceEpoch.toString(),
      title: '新しいコード譜',
      createdAt: now,
      updatedAt: now,
    );
    
    state = state.copyWith(
      currentSong: newSong,
      isEditing: true,
      hasUnsavedChanges: true,
    );
    
    return newSong;
  }
}