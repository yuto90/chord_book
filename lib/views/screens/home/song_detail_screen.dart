import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/song/song.dart';
import '../../widgets/chord_chart_widget.dart';
import 'song_editor_screen.dart';

class SongDetailScreen extends ConsumerWidget {
  final Song song;

  const SongDetailScreen({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SongEditorScreen(song: song),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Song info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (song.artist != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'by ${song.artist}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.speed, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'BPM: ${song.bpm}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.music_note, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            song.timeSignature,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Chord chart content
              if (song.lyricLines.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.music_note_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'コード譜が空です',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '編集ボタンから内容を追加してください',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ChordChartWidget(song: song),
            ],
          ),
        ),
      ),
    );
  }
}