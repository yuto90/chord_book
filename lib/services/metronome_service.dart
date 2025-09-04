import 'dart:async';
import 'package:flutter/services.dart';
import 'package:metronome/metronome.dart';
import '../models/metronome/metronome_data.dart';
import '../models/enums/metronome_state.dart';

class MetronomeService {
  Metronome? _metronome;
  StreamController<MetronomeData>? _controller;
  MetronomeData _currentData = const MetronomeData();
  Timer? _countInTimer;

  Stream<MetronomeData> get stream => _controller?.stream ?? const Stream.empty();
  MetronomeData get currentData => _currentData;

  void start(int bpm, int beatsPerMeasure, {int countInMeasures = 0}) {
    stop(); // Stop any existing metronome
    
    _controller = StreamController<MetronomeData>.broadcast();
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
    
    _controller!.add(_currentData);
    
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
        _controller!.add(_currentData);
        
        // カウントイン音とハプティクス
        _playCountInSound(currentCountInBeat, beatsPerMeasure);
        
        currentCountInBeat++;
      } else {
        // カウントイン終了、通常演奏開始
        timer.cancel();
        _currentData = _currentData.copyWith(
          isCountingIn: false,
          countInBeat: 0,
          currentBeat: 1,
        );
        _controller!.add(_currentData);
        _startMetronome(bpm, beatsPerMeasure);
      }
    });
  }

  void _startMetronome(int bpm, int beatsPerMeasure) {
    try {
      _metronome = Metronome.create(
        bpm: bpm,
        subdivision: Subdivision.quarter,
      );
      
      _metronome!.init().then((_) {
        _metronome!.play();
        
        // Beat tracking timer for UI updates
        final interval = Duration(milliseconds: (60000 / bpm).round());
        Timer.periodic(interval, (timer) {
          if (_currentData.state != MetronomeState.playing || _metronome == null) {
            timer.cancel();
            return;
          }
          
          final nextBeat = (_currentData.currentBeat % beatsPerMeasure) + 1;
          _currentData = _currentData.copyWith(currentBeat: nextBeat);
          _controller!.add(_currentData);
          
          // ハプティクスフィードバック
          if (_currentData.hapticsEnabled) {
            _triggerHaptics(_currentData.isStrongBeat);
          }
        });
      });
    } catch (e) {
      // Fallback to timer-based approach if metronome package fails
      _startTimerBasedMetronome(bpm, beatsPerMeasure);
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
      _controller!.add(_currentData);
      
      // 基本的なオーディオとハプティクス
      if (_currentData.audioEnabled) {
        SystemSound.play(_currentData.isStrongBeat 
            ? SystemSound.click 
            : SystemSound.click);
      }
      
      if (_currentData.hapticsEnabled) {
        _triggerHaptics(_currentData.isStrongBeat);
      }
    });
  }

  void _playCountInSound(int beat, int beatsPerMeasure) {
    if (_currentData.audioEnabled) {
      final isStrongBeat = ((beat - 1) % beatsPerMeasure) == 0;
      SystemSound.play(isStrongBeat ? SystemSound.click : SystemSound.click);
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
    _metronome?.stop();
    _metronome?.dispose();
    _metronome = null;
    _countInTimer?.cancel();
    _countInTimer = null;
    
    _currentData = _currentData.copyWith(
      state: MetronomeState.stopped,
      currentBeat: 0,
      isCountingIn: false,
      countInBeat: 0,
    );
    _controller?.add(_currentData);
    _controller?.close();
    _controller = null;
  }

  void pause() {
    _metronome?.pause();
    _countInTimer?.cancel();
    _countInTimer = null;
    _currentData = _currentData.copyWith(state: MetronomeState.paused);
    _controller?.add(_currentData);
  }

  void resume() {
    if (_currentData.state == MetronomeState.paused) {
      if (_currentData.isCountingIn) {
        start(_currentData.bpm, _currentData.beatsPerMeasure, 
              countInMeasures: _currentData.countInMeasures);
      } else {
        _metronome?.play();
        _currentData = _currentData.copyWith(state: MetronomeState.playing);
        _controller?.add(_currentData);
      }
    }
  }

  void setBpm(int bpm) {
    // BPM range: 30-300
    if (bpm < 30 || bpm > 300) return;
    
    final wasPlaying = _currentData.state.isPlaying;
    if (wasPlaying) {
      stop();
      start(bpm, _currentData.beatsPerMeasure, 
            countInMeasures: _currentData.countInMeasures);
    } else {
      _currentData = _currentData.copyWith(bpm: bpm);
      _controller?.add(_currentData);
    }
  }

  void setBeatsPerMeasure(int beatsPerMeasure) {
    if (beatsPerMeasure < 1 || beatsPerMeasure > 12) return;
    
    final wasPlaying = _currentData.state.isPlaying;
    if (wasPlaying) {
      stop();
      start(_currentData.bpm, beatsPerMeasure,
            countInMeasures: _currentData.countInMeasures);
    } else {
      _currentData = _currentData.copyWith(beatsPerMeasure: beatsPerMeasure);
      _controller?.add(_currentData);
    }
  }

  void setAudioEnabled(bool enabled) {
    _currentData = _currentData.copyWith(audioEnabled: enabled);
    _controller?.add(_currentData);
  }

  void setVisualEnabled(bool enabled) {
    _currentData = _currentData.copyWith(visualEnabled: enabled);
    _controller?.add(_currentData);
  }

  void setHapticsEnabled(bool enabled) {
    _currentData = _currentData.copyWith(hapticsEnabled: enabled);
    _controller?.add(_currentData);
  }

  void setCountInMeasures(int measures) {
    if (measures < 0 || measures > 4) return;
    
    _currentData = _currentData.copyWith(countInMeasures: measures);
    _controller?.add(_currentData);
  }

  void addTapTempo() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final taps = List<int>.from(_currentData.tapTimestamps);
    
    taps.add(now);
    
    // Keep only last 8 taps for calculation
    if (taps.length > 8) {
      taps.removeAt(0);
    }
    
    // Calculate BPM if we have at least 2 taps
    if (taps.length >= 2) {
      final intervals = <int>[];
      for (int i = 1; i < taps.length; i++) {
        intervals.add(taps[i] - taps[i - 1]);
      }
      
      if (intervals.isNotEmpty) {
        final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
        final calculatedBpm = (60000 / avgInterval).round();
        
        // Apply BPM if within valid range
        if (calculatedBpm >= 30 && calculatedBpm <= 300) {
          setBpm(calculatedBpm);
        }
      }
    }
    
    _currentData = _currentData.copyWith(tapTimestamps: taps);
    _controller?.add(_currentData);
  }

  void clearTapTempo() {
    _currentData = _currentData.copyWith(tapTimestamps: []);
    _controller?.add(_currentData);
  }

  void dispose() {
    stop();
  }
}