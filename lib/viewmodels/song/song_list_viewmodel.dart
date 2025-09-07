import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/song/song.dart';
import '../../models/song/lyric_line.dart';
import '../../models/song/chord_block.dart';
import '../../models/chord/chord_shape.dart';

part 'song_list_viewmodel.g.dart';

@riverpod
class SongListViewModel extends _$SongListViewModel {
  @override
  Future<List<Song>> build() async {
    // For now, return sample data
    return _getSampleSongs();
  }

  Future<void> deleteSong(String id) async {
    final currentSongs = await future;
    final updatedSongs = currentSongs.where((song) => song.id != id).toList();
    state = AsyncValue.data(updatedSongs);
  }

  Future<void> addSong(Song song) async {
    final currentSongs = await future;
    final updatedSongs = [...currentSongs, song];
    state = AsyncValue.data(updatedSongs);
  }

  List<Song> _getSampleSongs() {
    final now = DateTime.now();
    
    return [
      Song(
        id: '1',
        title: '音住んでた',
        artist: 'サンプルアーティスト',
        lyricLines: [
          LyricLine(
            id: '1',
            text: '音住んでた　小さな部屋は　今は誰かが　住んでんだ',
            order: 0,
            strummingPattern: '↓~↓~~↑↓↑ ↓~↓~~↑↓↑ ↓~↓~~↑↓↑ ↓~↓~~↑↓↑',
            chordBlocks: [
              ChordBlock(
                id: '1',
                chordName: 'Cadd9',
                position: 0.0,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'Cadd9',
                  fretPositions: [-1, 3, 2, 0, 3, 0],
                ),
              ),
              ChordBlock(
                id: '2', 
                chordName: 'Cadd9',
                position: 0.25,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'Cadd9',
                  fretPositions: [-1, 3, 2, 0, 3, 0],
                ),
              ),
              ChordBlock(
                id: '3',
                chordName: 'G/B',
                position: 0.5,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'G/B',
                  fretPositions: [-1, 2, 0, 0, 3, 3],
                ),
              ),
              ChordBlock(
                id: '4',
                chordName: 'G(omit3)',
                position: 0.75,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'G(omit3)',
                  fretPositions: [3, -1, 0, 0, 3, 3],
                ),
              ),
            ],
          ),
        ],
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Song(
        id: '2',
        title: 'コード練習',
        lyricLines: [
          LyricLine(
            id: '1',
            text: 'C G Am F のコード進行',
            order: 0,
            chordBlocks: [
              ChordBlock(
                id: '1',
                chordName: 'C',
                position: 0.0,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'C',
                  fretPositions: [-1, 3, 2, 0, 1, 0],
                ),
              ),
              ChordBlock(
                id: '2',
                chordName: 'G',
                position: 0.25,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'G',
                  fretPositions: [3, 2, 0, 0, 3, 3],
                ),
              ),
              ChordBlock(
                id: '3',
                chordName: 'Am',
                position: 0.5,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'Am',
                  fretPositions: [-1, 0, 2, 2, 1, 0],
                ),
              ),
              ChordBlock(
                id: '4',
                chordName: 'F',
                position: 0.75,
                duration: 1.0,
                chordShape: ChordShape(
                  chordName: 'F',
                  fretPositions: [1, 3, 3, 2, 1, 1],
                ),
              ),
            ],
          ),
        ],
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
      ),
    ];
  }
}