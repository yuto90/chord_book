import 'package:flutter/foundation.dart';
import '../../models/metronome/metronome_data.dart';
import '../../models/enums/metronome_state.dart';
import '../../services/metronome_service.dart';

class MetronomeViewModel extends ChangeNotifier {
  final MetronomeService _metronomeService = MetronomeService();
  MetronomeData _data = const MetronomeData();

  MetronomeData get data => _data;
  int get bpm => _data.bpm;
  int get beatsPerMeasure => _data.beatsPerMeasure;
  MetronomeState get state => _data.state;
  int get currentBeat => _data.currentBeat;

  MetronomeViewModel() {
    _metronomeService.stream.listen((data) {
      _data = data;
      notifyListeners();
    });
  }

  void start() {
    _metronomeService.start(_data.bpm, _data.beatsPerMeasure);
  }

  void stop() {
    _metronomeService.stop();
  }

  void pause() {
    _metronomeService.pause();
  }

  void resume() {
    _metronomeService.resume();
  }

  void setBpm(int bpm) {
    if (bpm >= 40 && bpm <= 200) {
      _metronomeService.setBpm(bpm);
    }
  }

  void setBeatsPerMeasure(int beatsPerMeasure) {
    if (beatsPerMeasure >= 1 && beatsPerMeasure <= 12) {
      _metronomeService.setBeatsPerMeasure(beatsPerMeasure);
    }
  }

  void togglePlayPause() {
    if (_data.state.isPlaying) {
      pause();
    } else if (_data.state.isPaused) {
      resume();
    } else {
      start();
    }
  }

  @override
  void dispose() {
    _metronomeService.dispose();
    super.dispose();
  }
}