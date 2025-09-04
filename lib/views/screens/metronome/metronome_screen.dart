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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header with tempo display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  '${metronomeData.bpm} BPM',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Beat indicator
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Beat visualization
                      SizedBox(
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(metronomeData.beatsPerMeasure, (index) {
                            final beatNumber = index + 1;
                            final isCurrentBeat = beatNumber == metronomeData.currentBeat && metronomeData.state.isPlaying;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: isCurrentBeat ? Colors.red : Colors.grey[300],
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
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // BPM decrease
                          ElevatedButton(
                            onPressed: () => metronomeNotifier.setBpm(metronomeData.bpm - 1),
                            child: const Icon(Icons.remove),
                          ),
                          
                          // Play/Pause button
                          ElevatedButton(
                            onPressed: metronomeNotifier.togglePlayPause,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: metronomeData.state.isPlaying ? Colors.red : Colors.green,
                              minimumSize: const Size(80, 80),
                              shape: const CircleBorder(),
                            ),
                            child: Icon(
                              metronomeData.state.isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          
                          // BPM increase
                          ElevatedButton(
                            onPressed: () => metronomeNotifier.setBpm(metronomeData.bpm + 1),
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Stop button
                      ElevatedButton(
                        onPressed: metronomeNotifier.stop,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('停止'),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Time signature controls
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
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
                      items: [2, 3, 4, 5, 6].map((beats) {
                        return DropdownMenuItem(
                          value: beats,
                          child: Text('$beats/4'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}