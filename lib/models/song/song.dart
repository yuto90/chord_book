import 'package:freezed_annotation/freezed_annotation.dart';
import 'lyric_line.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    String? artist,
    @Default([]) List<LyricLine> lyricLines,
    @Default(120) int bpm,
    @Default('4/4') String timeSignature,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}