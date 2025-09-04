import 'package:flutter/material.dart';
import '../../viewmodels/metronome/metronome_view_model.dart';
import '../../models/enums/metronome_state.dart';

class AppHeaderWidget extends StatefulWidget implements PreferredSizeWidget {
  final MetronomeViewModel metronomeViewModel;
  
  const AppHeaderWidget({
    super.key,
    required this.metronomeViewModel,
  });

  @override
  State<AppHeaderWidget> createState() => _AppHeaderWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppHeaderWidgetState extends State<AppHeaderWidget> {
  @override
  void initState() {
    super.initState();
    widget.metronomeViewModel.addListener(_onMetronomeStateChanged);
  }

  @override
  void dispose() {
    widget.metronomeViewModel.removeListener(_onMetronomeStateChanged);
    super.dispose();
  }

  void _onMetronomeStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final metronome = widget.metronomeViewModel;
    
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
                  color: metronome.state.isPlaying ? Colors.red : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${metronome.bpm}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: metronome.state.isPlaying ? Colors.red : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Current beat indicator (only show when playing)
          if (metronome.state.isPlaying)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${metronome.currentBeat}',
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
          onPressed: () => metronome.setBpm(metronome.bpm - 1),
          icon: const Icon(Icons.remove, size: 18),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        // Play/Pause button
        IconButton(
          onPressed: metronome.togglePlayPause,
          icon: Icon(
            metronome.state.isPlaying ? Icons.pause : Icons.play_arrow,
            color: metronome.state.isPlaying ? Colors.red : Colors.grey[700],
          ),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        // BPM controls
        IconButton(
          onPressed: () => metronome.setBpm(metronome.bpm + 1),
          icon: const Icon(Icons.add, size: 18),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        // Stop button
        IconButton(
          onPressed: metronome.stop,
          icon: const Icon(Icons.stop, size: 18),
          color: Colors.grey[600],
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        
        const SizedBox(width: 8),
      ],
    );
  }
}