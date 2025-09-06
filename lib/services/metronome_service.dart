import 'dart:async';
import 'package:flutter/services.dart';
import 'package:metronome/metronome.dart';
import '../models/metronome/metronome_data.dart';
import '../models/enums/metronome_state.dart';

class MetronomeService {
  Metronome? _metronome;
  late final StreamController<MetronomeData> _controller;
  MetronomeData _currentData = const MetronomeData();
  Timer? _countInTimer;

  // メイン/アクセント用クリック音アセットパス（存在するファイルに差し替えてください）
  static const String _mainClickPath = 'assets/audio/pon.mp3';
  static const String _accentClickPath = 'assets/audio/finish.wav';

  Stream<MetronomeData> get stream => _controller.stream;
  MetronomeData get currentData => _currentData;

  MetronomeService() {
    _controller = StreamController<MetronomeData>.broadcast();
  }

  void start(int bpm, int beatsPerMeasure, {int countInMeasures = 0}) {
    stop(); // Stop any existing metronome
    _currentData = MetronomeData(
      bpm: bpm,
      beatsPerMeasure: beatsPerMeasure,
      state: MetronomeState.playing,
      currentBeat: 1,
      countInMeasures: countInMeasures,
      isCountingIn: countInMeasures > 0,
      countInBeat: countInMeasures > 0 ? 1 : 0,
      audioEnabled: _currentData.audioEnabled,
      visualEnabled: _currentData.visualEnabled,
      hapticsEnabled: _currentData.hapticsEnabled,
    );
    _controller.add(_currentData);
    if (countInMeasures > 0) {
      _startCountIn(bpm, beatsPerMeasure, countInMeasures);
    } else {
      _startMetronome(bpm, beatsPerMeasure);
    }
  }

  void _startCountIn(int bpm, int beatsPerMeasure, int countInMeasures) {
    final interval = Duration(milliseconds: (60000 / bpm).round());
    int totalCountInBeats = countInMeasures * beatsPerMeasure;
    int currentCountInBeat = 1;
    _countInTimer = Timer.periodic(interval, (timer) {
      if (currentCountInBeat <= totalCountInBeats) {
        _currentData = _currentData.copyWith(
          countInBeat: currentCountInBeat,
          currentBeat: ((currentCountInBeat - 1) % beatsPerMeasure) + 1,
        );
        _controller.add(_currentData);
        _playCountInSound(currentCountInBeat, beatsPerMeasure);
        currentCountInBeat++;
      } else {
        timer.cancel();
        _currentData = _currentData.copyWith(
          isCountingIn: false,
          countInBeat: 0,
          currentBeat: 1,
        );
        _controller.add(_currentData);
        _startMetronome(bpm, beatsPerMeasure);
      }
    });
  }

  // ===== 修正: metronomeパッケージ正しい初期化 =====
  Future<bool> _initializeMetronome(
      {required int bpm, required int beatsPerMeasure}) async {
    _metronome = Metronome();
    try {
      await _metronome!.init(
        _mainClickPath,
        bpm: bpm,
        enableTickCallback: true,
        accentedPath: _accentClickPath,
      );
      return true; // 成功
    } catch (e) {
      // 初期化失敗 -> メトロノーム無効化し fallback
      _metronome = null;
      _startTimerBasedMetronome(bpm, beatsPerMeasure);
      return false;
    }
  }

  void _handleTick(int beatsPerMeasure) {
    if (_currentData.state != MetronomeState.playing) return;
    final nextBeat = (_currentData.currentBeat % beatsPerMeasure) + 1;
    _currentData = _currentData.copyWith(currentBeat: nextBeat);
    _controller.add(_currentData);
    if (_currentData.hapticsEnabled) {
      _triggerHaptics(nextBeat == 1);
    }
  }

  void _startMetronome(int bpm, int beatsPerMeasure) async {
    final success =
        await _initializeMetronome(bpm: bpm, beatsPerMeasure: beatsPerMeasure);
    if (!success) return; // fallback 動作中
    if (_metronome != null &&
        _currentData.state == MetronomeState.playing &&
        !_currentData.isCountingIn) {
      try {
        _metronome!.onListenTick((_) => _handleTick(beatsPerMeasure));
        await _metronome!.play(bpm); // 初期化成功時のみ再生
      } catch (_) {
        _metronome = null;
        _startTimerBasedMetronome(bpm, beatsPerMeasure);
      }
    }
  }

  void _startTimerBasedMetronome(int bpm, int beatsPerMeasure) {
    final interval = Duration(milliseconds: (60000 / bpm).round());
    Timer.periodic(interval, (timer) {
      if (_currentData.state != MetronomeState.playing) {
        timer.cancel();
        return;
      }
      final nextBeat = (_currentData.currentBeat % beatsPerMeasure) + 1;
      _currentData = _currentData.copyWith(currentBeat: nextBeat);
      _controller.add(_currentData);
      if (_currentData.audioEnabled) {
        SystemSound.play(SystemSoundType.click);
      }
      if (_currentData.hapticsEnabled) {
        _triggerHaptics(nextBeat == 1);
      }
    });
  }

  void _playCountInSound(int beat, int beatsPerMeasure) {
    if (_currentData.audioEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    if (_currentData.hapticsEnabled) {
      _triggerHaptics(((beat - 1) % beatsPerMeasure) == 0);
    }
  }

  void _triggerHaptics(bool isStrongBeat) {
    if (isStrongBeat) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  void stop() {
    // v1.1.5: destroy() でクリーンアップ
    try {
      _metronome?.stop();
      _metronome?.destroy();
    } catch (_) {}
    _metronome = null;
    _countInTimer?.cancel();
    _countInTimer = null;
    _currentData = _currentData.copyWith(
      state: MetronomeState.stopped,
      currentBeat: 0,
      isCountingIn: false,
      countInBeat: 0,
    );
    _controller.add(_currentData);
  }

  void pause() {
    try {
      _metronome?.pause();
    } catch (_) {}
    _countInTimer?.cancel();
    _countInTimer = null;
    _currentData = _currentData.copyWith(state: MetronomeState.paused);
    _controller.add(_currentData);
  }

  void resume() {
    if (_currentData.state == MetronomeState.paused) {
      if (_currentData.isCountingIn) {
        start(_currentData.bpm, _currentData.beatsPerMeasure,
            countInMeasures: _currentData.countInMeasures);
      } else {
        if (_metronome == null) {
          // 破棄済みなら再初期化
          _startMetronome(_currentData.bpm, _currentData.beatsPerMeasure);
        } else {
          try {
            _metronome?.onListenTick(
                (_) => _handleTick(_currentData.beatsPerMeasure));
            _metronome?.play(_currentData.bpm);
          } catch (_) {
            _metronome = null;
            _startMetronome(_currentData.bpm, _currentData.beatsPerMeasure);
          }
        }
        _currentData = _currentData.copyWith(state: MetronomeState.playing);
        _controller.add(_currentData);
      }
    }
  }

  void setBpm(int bpm) {
    if (bpm < 30 || bpm > 300) return;
    final wasPlaying = _currentData.state.isPlaying;
    if (wasPlaying) {
      final beatsPerMeasure = _currentData.beatsPerMeasure;
      final countIn = _currentData.countInMeasures;
      start(bpm, beatsPerMeasure, countInMeasures: countIn);
    } else {
      _currentData = _currentData.copyWith(bpm: bpm);
      _controller.add(_currentData);
    }
  }

  void setBeatsPerMeasure(int beatsPerMeasure) {
    if (beatsPerMeasure < 1 || beatsPerMeasure > 12) return;
    final wasPlaying = _currentData.state.isPlaying;
    if (wasPlaying) {
      start(_currentData.bpm, beatsPerMeasure,
          countInMeasures: _currentData.countInMeasures);
    } else {
      _currentData = _currentData.copyWith(beatsPerMeasure: beatsPerMeasure);
      _controller.add(_currentData);
    }
  }

  void setAudioEnabled(bool enabled) {
    _currentData = _currentData.copyWith(audioEnabled: enabled);
    _controller.add(_currentData);
  }

  void setVisualEnabled(bool enabled) {
    _currentData = _currentData.copyWith(visualEnabled: enabled);
    _controller.add(_currentData);
  }

  void setHapticsEnabled(bool enabled) {
    _currentData = _currentData.copyWith(hapticsEnabled: enabled);
    _controller.add(_currentData);
  }

  void setCountInMeasures(int measures) {
    if (measures < 0 || measures > 4) return;
    _currentData = _currentData.copyWith(countInMeasures: measures);
    _controller.add(_currentData);
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
