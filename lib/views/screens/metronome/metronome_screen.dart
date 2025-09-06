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
              
              // Centered main content area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Beat visualization
                      _buildBeatVisualization(metronomeData),
                      
                      const SizedBox(height: 40),
                      
                      // Centered main play button
                      _buildCenteredPlayButton(metronomeData, metronomeNotifier),
                      
                      const SizedBox(height: 32),
                      
                      // Secondary controls (Stop and Count-in)
                      _buildSecondaryControls(metronomeData, metronomeNotifier),
                      
                      const SizedBox(height: 40),
                      
                      // BPM adjustment controls
                      _buildBpmControls(metronomeData, metronomeNotifier),
                    ],
                  ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // BPM Display - centered and larger
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () => _showBpmInputDialog(context, metronomeData, metronomeNotifier),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Text(
                      '${metronomeData.bpm}',
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'BPM (タップして設定)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Settings toggle
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => _showSettingsDialog(context, metronomeData, metronomeNotifier),
            icon: const Icon(Icons.settings, size: 28),
            padding: const EdgeInsets.all(12),
          ),
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

  Widget _buildCenteredPlayButton(metronomeData, metronomeNotifier) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: metronomeNotifier.togglePlayPause,
        style: ElevatedButton.styleFrom(
          backgroundColor: metronomeData.state.isPlaying ? Colors.red[600] : Colors.green[600],
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 120),
          shape: const CircleBorder(),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          metronomeData.state.isPlaying ? Icons.pause : Icons.play_arrow,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSecondaryControls(metronomeData, metronomeNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Stop button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: metronomeNotifier.stop,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 80),
              shape: const CircleBorder(),
              elevation: 0,
            ),
            child: const Icon(Icons.stop, size: 36, color: Colors.white),
          ),
        ),
        
        // Count-in button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: metronomeData.countInMeasures > 0
                ? () => metronomeNotifier.start(countInMeasures: metronomeData.countInMeasures)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: metronomeData.countInMeasures > 0 ? Colors.orange[600] : Colors.grey[400],
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 80),
              shape: const CircleBorder(),
              elevation: 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.looks_one, size: 20, color: Colors.white),
                Text(
                  '${metronomeData.countInMeasures}',
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBpmControls(metronomeData, metronomeNotifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          const Text(
            'BPM調整',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // BPM -10
              _buildBpmButton(
                label: '-10',
                onPressed: () => metronomeNotifier.adjustBpm(-10),
                color: Colors.red[400]!,
              ),
              
              // BPM -1
              _buildBpmButton(
                icon: Icons.remove,
                onPressed: () => metronomeNotifier.adjustBpm(-1),
                color: Colors.red[300]!,
              ),
              
              // BPM +1
              _buildBpmButton(
                icon: Icons.add,
                onPressed: () => metronomeNotifier.adjustBpm(1),
                color: Colors.blue[300]!,
              ),
              
              // BPM +10
              _buildBpmButton(
                label: '+10',
                onPressed: () => metronomeNotifier.adjustBpm(10),
                color: Colors.blue[400]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBpmButton({
    String? label,
    IconData? icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 64),
          shape: const CircleBorder(),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: label != null
            ? Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            : Icon(
                icon,
                size: 28,
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _buildBottomControls(metronomeData, metronomeNotifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_note, color: Colors.grey),
          const SizedBox(width: 8),
          const Text(
            '拍子: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<int>(
              value: metronomeData.beatsPerMeasure,
              underline: const SizedBox(),
              onChanged: (value) {
                if (value != null) {
                  metronomeNotifier.setBeatsPerMeasure(value);
                }
              },
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              items: [2, 3, 4, 5, 6, 7, 8].map((beats) {
                return DropdownMenuItem(
                  value: beats,
                  child: Text('$beats/4'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
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