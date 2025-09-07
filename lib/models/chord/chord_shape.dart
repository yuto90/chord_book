import 'package:freezed_annotation/freezed_annotation.dart';

part 'chord_shape.freezed.dart';
part 'chord_shape.g.dart';

@freezed
class ChordShape with _$ChordShape {
  const factory ChordShape({
    required String chordName,
    required List<int> fretPositions, // 6 strings, -1 = not played, 0 = open
    @Default(0) int baseFret, // Starting fret number for display
    List<int>? fingering, // Finger numbers (1-4), null for unspecified
    List<String>? mutedStrings, // Which strings are muted
  }) = _ChordShape;

  factory ChordShape.fromJson(Map<String, dynamic> json) => _$ChordShapeFromJson(json);
}