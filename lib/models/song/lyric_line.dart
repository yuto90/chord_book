import 'package:freezed_annotation/freezed_annotation.dart';
import 'chord_block.dart';

part 'lyric_line.freezed.dart';
part 'lyric_line.g.dart';

@freezed
class LyricLine with _$LyricLine {
  const factory LyricLine({
    required String id,
    required String text,
    @Default([]) List<ChordBlock> chordBlocks,
    String? strummingPattern,
    @Default(0) int order,
  }) = _LyricLine;

  factory LyricLine.fromJson(Map<String, dynamic> json) => _$LyricLineFromJson(json);
}