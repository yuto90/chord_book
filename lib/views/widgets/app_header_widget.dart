import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/metronome/metronome_view_model.dart';
import '../../models/enums/metronome_state.dart';

class AppHeaderWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metronomeData = ref.watch(metronomeProvider);
    final metronomeNotifier = ref.read(metronomeProvider.notifier);
    
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          // Metronome BPM display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.music_note,
                  size: 16,
                  color: metronomeData.state.isPlaying ? Colors.red : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${metronomeData.bpm}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: metronomeData.state.isPlaying ? Colors.red : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Current beat indicator (only show when playing)
          if (metronomeData.state.isPlaying)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${metronomeData.currentBeat}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      actions: [
        // BPM controls
        IconButton(
          onPressed: () => metronomeNotifier.setBpm(metronomeData.bpm - 1),
          icon: const Icon(Icons.remove, size: 18),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        // Play/Pause button
        IconButton(
          onPressed: metronomeNotifier.togglePlayPause,
          icon: Icon(
            metronomeData.state.isPlaying ? Icons.pause : Icons.play_arrow,
            color: metronomeData.state.isPlaying ? Colors.red : Colors.grey[700],
          ),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        // BPM controls
        IconButton(
          onPressed: () => metronomeNotifier.setBpm(metronomeData.bpm + 1),
          icon: const Icon(Icons.add, size: 18),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        // Stop button
        IconButton(
          onPressed: metronomeNotifier.stop,
          icon: const Icon(Icons.stop, size: 18),
          color: Colors.grey[600],
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}