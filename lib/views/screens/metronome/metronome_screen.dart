import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodels/metronome/metronome_view_model.dart';
import '../../../models/enums/metronome_state.dart';

class MetronomeScreen extends ConsumerWidget {
  const MetronomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metronomeData = ref.watch(metronomeProvider);
    final metronomeNotifier = ref.read(metronomeProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header with tempo display and settings
              _buildHeader(context, metronomeData, metronomeNotifier),
              
              const SizedBox(height: 16),
              
              // Beat indicator
              Expanded(
                child: Column(
                  children: [
                    // Count-in or beat visualization
                    _buildBeatVisualization(metronomeData),
                    
                    const SizedBox(height: 32),
                    
                    // Main controls
                    _buildMainControls(metronomeData, metronomeNotifier),
                    
                    const SizedBox(height: 24),
                    
                    // BPM controls
                    _buildBpmControls(metronomeData, metronomeNotifier),
                  ],
                ),
              ),
              
              // Bottom controls
              _buildBottomControls(metronomeData, metronomeNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, metronomeData, metronomeNotifier) {
    return Row(
      children: [
        // BPM Display
        Expanded(
          child: GestureDetector(
            onTap: () => _showBpmInputDialog(context, metronomeData, metronomeNotifier),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '${metronomeData.bpm}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('BPM (タップして設定)'),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Settings toggle
        IconButton(
          onPressed: () => _showSettingsDialog(context, metronomeData, metronomeNotifier),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _buildBeatVisualization(metronomeData) {
    if (metronomeData.isInCountIn) {
      return _buildCountInVisualization(metronomeData);
    }
    return _buildNormalBeatVisualization(metronomeData);
  }

  Widget _buildCountInVisualization(metronomeData) {
    return Container(
      height: 120,
      child: Column(
        children: [
          const Text(
            'カウントイン',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '${metronomeData.countInBeat}',
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalBeatVisualization(metronomeData) {
    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(metronomeData.beatsPerMeasure, (index) {
          final beatNumber = index + 1;
          final isCurrentBeat = beatNumber == metronomeData.currentBeat && 
                               metronomeData.state.isPlaying &&
                               metronomeData.visualEnabled;
          final isStrongBeat = beatNumber == 1;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: isCurrentBeat 
                  ? (isStrongBeat ? Colors.red : Colors.blue)
                  : Colors.grey[300],
              child: Text(
                '$beatNumber',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isCurrentBeat ? Colors.white : Colors.black54,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainControls(metronomeData, metronomeNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Stop button
        ElevatedButton(
          onPressed: metronomeNotifier.stop,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            minimumSize: const Size(60, 60),
            shape: const CircleBorder(),
          ),
          child: const Icon(Icons.stop, color: Colors.white),
        ),
        
        // Play/Pause button
        ElevatedButton(
          onPressed: metronomeNotifier.togglePlayPause,
          style: ElevatedButton.styleFrom(
            backgroundColor: metronomeData.state.isPlaying ? Colors.red : Colors.green,
            minimumSize: const Size(100, 100),
            shape: const CircleBorder(),
          ),
          child: Icon(
            metronomeData.state.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 50,
            color: Colors.white,
          ),
        ),
        
        // Count-in button
        ElevatedButton(
          onPressed: metronomeData.countInMeasures > 0
              ? () => metronomeNotifier.start(countInMeasures: metronomeData.countInMeasures)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(60, 60),
            shape: const CircleBorder(),
          ),
          child: Text(
            '${metronomeData.countInMeasures}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildBpmControls(metronomeData, metronomeNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // BPM -10
        ElevatedButton(
          onPressed: () => metronomeNotifier.adjustBpm(-10),
          child: const Text('-10'),
        ),
        
        // BPM -1
        ElevatedButton(
          onPressed: () => metronomeNotifier.adjustBpm(-1),
          child: const Icon(Icons.remove),
        ),
        
        // BPM +1
        ElevatedButton(
          onPressed: () => metronomeNotifier.adjustBpm(1),
          child: const Icon(Icons.add),
        ),
        
        // BPM +10
        ElevatedButton(
          onPressed: () => metronomeNotifier.adjustBpm(10),
          child: const Text('+10'),
        ),
      ],
    );
  }

  Widget _buildBottomControls(metronomeData, metronomeNotifier) {
    return Column(
      children: [
        // Time signature controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('拍子: '),
            DropdownButton<int>(
              value: metronomeData.beatsPerMeasure,
              onChanged: (value) {
                if (value != null) {
                  metronomeNotifier.setBeatsPerMeasure(value);
                }
              },
              items: [2, 3, 4, 5, 6, 7, 8].map((beats) {
                return DropdownMenuItem(
                  value: beats,
                  child: Text('$beats/4'),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  void _showBpmInputDialog(BuildContext context, metronomeData, metronomeNotifier) {
    final TextEditingController bpmController = TextEditingController(
      text: metronomeData.bpm.toString(),
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('BPM設定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bpmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'BPM (30-300)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final bpm = int.tryParse(value);
                if (bpm != null && bpm >= 30 && bpm <= 300) {
                  metronomeNotifier.setBpm(bpm);
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              '設定範囲: 30-300 BPM',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              final bpm = int.tryParse(bpmController.text);
              if (bpm != null && bpm >= 30 && bpm <= 300) {
                metronomeNotifier.setBpm(bpm);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('BPMは30-300の範囲で入力してください'),
                  ),
                );
              }
            },
            child: const Text('設定'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, metronomeData, metronomeNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('メトロノーム設定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Audio setting
            SwitchListTile(
              title: const Text('音声出力'),
              value: metronomeData.audioEnabled,
              onChanged: metronomeNotifier.setAudioEnabled,
            ),
            
            // Visual setting
            SwitchListTile(
              title: const Text('ビジュアル表示'),
              value: metronomeData.visualEnabled,
              onChanged: metronomeNotifier.setVisualEnabled,
            ),
            
            // Haptics setting
            SwitchListTile(
              title: const Text('ハプティクス'),
              value: metronomeData.hapticsEnabled,
              onChanged: metronomeNotifier.setHapticsEnabled,
            ),
            
            const Divider(),
            
            // Count-in setting
            Row(
              children: [
                const Text('カウントイン: '),
                DropdownButton<int>(
                  value: metronomeData.countInMeasures,
                  onChanged: (value) {
                    if (value != null) {
                      metronomeNotifier.setCountInMeasures(value);
                    }
                  },
                  items: [0, 1, 2, 3, 4].map((measures) {
                    return DropdownMenuItem(
                      value: measures,
                      child: Text(measures == 0 ? 'OFF' : '$measures小節'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}