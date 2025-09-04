import 'dart:async';
import '../models/metronome/metronome_data.dart';
import '../models/enums/metronome_state.dart';

class MetronomeService {
  Timer? _timer;
  StreamController<MetronomeData>? _controller;
  MetronomeData _currentData = const MetronomeData();

  Stream<MetronomeData> get stream => _controller?.stream ?? const Stream.empty();
  MetronomeData get currentData => _currentData;

  void start(int bpm, int beatsPerMeasure) {
    stop(); // Stop any existing metronome
    
    _controller = StreamController<MetronomeData>.broadcast();
    _currentData = MetronomeData(
      bpm: bpm,
      beatsPerMeasure: beatsPerMeasure,
      state: MetronomeState.playing,
      currentBeat: 1,
    );
    
    // Calculate interval in milliseconds
    final interval = Duration(milliseconds: (60000 / bpm).round());
    
    _controller!.add(_currentData);
    
    _timer = Timer.periodic(interval, (timer) {
      _currentData = _currentData.copyWith(
        currentBeat: (_currentData.currentBeat % beatsPerMeasure) + 1,
      );
      _controller!.add(_currentData);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _currentData = _currentData.copyWith(
      state: MetronomeState.stopped,
      currentBeat: 0,
    );
    _controller?.add(_currentData);
    _controller?.close();
    _controller = null;
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    _currentData = _currentData.copyWith(state: MetronomeState.paused);
    _controller?.add(_currentData);
  }

  void resume() {
    if (_currentData.state == MetronomeState.paused) {
      start(_currentData.bpm, _currentData.beatsPerMeasure);
    }
  }

  void setBpm(int bpm) {
    final wasPlaying = _currentData.state.isPlaying;
    if (wasPlaying) {
      stop();
      start(bpm, _currentData.beatsPerMeasure);
    } else {
      _currentData = _currentData.copyWith(bpm: bpm);
      _controller?.add(_currentData);
    }
  }

  void setBeatsPerMeasure(int beatsPerMeasure) {
    final wasPlaying = _currentData.state.isPlaying;
    if (wasPlaying) {
      stop();
      start(_currentData.bpm, beatsPerMeasure);
    } else {
      _currentData = _currentData.copyWith(beatsPerMeasure: beatsPerMeasure);
      _controller?.add(_currentData);
    }
  }

  void dispose() {
    stop();
  }
}