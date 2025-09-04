enum MetronomeState {
  stopped,
  playing,
  paused;

  bool get isPlaying => this == MetronomeState.playing;
  bool get isStopped => this == MetronomeState.stopped;
  bool get isPaused => this == MetronomeState.paused;
}