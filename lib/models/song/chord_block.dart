import 'package:freezed_annotation/freezed_annotation.dart';
import '../chord/chord_shape.dart';
import '../enums/chord_block_type.dart';

part 'chord_block.freezed.dart';
part 'chord_block.g.dart';

@freezed
class ChordBlock with _$ChordBlock {
  const factory ChordBlock({
    required String id,
    required String chordName,
    ChordShape? chordShape,
    @Default(ChordBlockType.chord) ChordBlockType type,
    @Default(0) double position, // Position in the line (0.0 to 1.0)
    @Default(1) double duration, // Duration in beats
  }) = _ChordBlock;

  factory ChordBlock.fromJson(Map<String, dynamic> json) => _$ChordBlockFromJson(json);
}