enum ChordBlockType {
  chord,
  rest,
  repeat;

  String get label {
    switch (this) {
      case ChordBlockType.chord:
        return 'コード';
      case ChordBlockType.rest:
        return '休符';
      case ChordBlockType.repeat:
        return 'リピート';
    }
  }
}