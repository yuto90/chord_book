import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/song/song.dart';
import '../../models/song/lyric_line.dart';
import '../../models/song/chord_block.dart';
import '../../models/chord/chord_shape.dart';
import '../../viewmodels/song/song_editor_viewmodel.dart';

class SongEditorFormWidget extends ConsumerStatefulWidget {
  final Song song;
  final Function(Song) onSongChanged;

  const SongEditorFormWidget({
    super.key,
    required this.song,
    required this.onSongChanged,
  });

  @override
  ConsumerState<SongEditorFormWidget> createState() => _SongEditorFormWidgetState();
}

class _SongEditorFormWidgetState extends ConsumerState<SongEditorFormWidget> {
  late TextEditingController _titleController;
  late TextEditingController _artistController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.song.title);
    _artistController = TextEditingController(text: widget.song.artist ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(songEditorViewModelProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Song metadata
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'タイトル',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      notifier.updateTitle(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _artistController,
                    decoration: const InputDecoration(
                      labelText: 'アーティスト (オプション)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      notifier.updateArtist(value.isEmpty ? null : value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lyric lines section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '歌詞とコード',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          notifier.addLyricLine('新しい行');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('行を追加'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Lyric lines
                  ...widget.song.lyricLines.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final lyricLine = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildLyricLineEditor(lyricLine, index, notifier),
                      );
                    },
                  ),

                  if (widget.song.lyricLines.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.music_note_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '歌詞がありません',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '「行を追加」ボタンから歌詞を追加してください',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLyricLineEditor(LyricLine lyricLine, int index, SongEditorViewModel notifier) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Lyric text editor
          TextFormField(
            initialValue: lyricLine.text,
            decoration: InputDecoration(
              hintText: '歌詞を入力...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: IconButton(
                icon: const Icon(Icons.music_note),
                onPressed: () => _showAddChordDialog(lyricLine.id, notifier),
                tooltip: 'コードを追加',
              ),
            ),
            onChanged: (value) {
              notifier.updateLyricLine(lyricLine.id, value);
            },
          ),
          
          // Chord blocks
          if (lyricLine.chordBlocks.isNotEmpty) ...[
            const Divider(height: 1),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                children: lyricLine.chordBlocks.map((chordBlock) {
                  return Chip(
                    label: Text(chordBlock.chordName),
                    onDeleted: () {
                      // TODO: Implement chord removal
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddChordDialog(String lineId, SongEditorViewModel notifier) {
    final chordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('コードを追加'),
        content: TextFormField(
          controller: chordController,
          decoration: const InputDecoration(
            labelText: 'コード名 (例: C, Am, G7)',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              final chordName = chordController.text.trim();
              if (chordName.isNotEmpty) {
                final chordBlock = ChordBlock(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  chordName: chordName,
                  chordShape: _getChordShape(chordName), // Get predefined chord shape
                );
                notifier.addChordToLine(lineId, chordBlock);
                Navigator.of(context).pop();
              }
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }

  ChordShape? _getChordShape(String chordName) {
    // Return predefined chord shapes for common chords
    final commonChords = {
      'C': ChordShape(
        chordName: 'C',
        fretPositions: [-1, 3, 2, 0, 1, 0], // x32010
      ),
      'G': ChordShape(
        chordName: 'G',
        fretPositions: [3, 2, 0, 0, 3, 3], // 320033
      ),
      'Am': ChordShape(
        chordName: 'Am',
        fretPositions: [-1, 0, 2, 2, 1, 0], // x02210
      ),
      'F': ChordShape(
        chordName: 'F',
        fretPositions: [1, 3, 3, 2, 1, 1], // 133211
      ),
      'Cadd9': ChordShape(
        chordName: 'Cadd9',
        fretPositions: [-1, 3, 2, 0, 3, 0], // x32030
      ),
      'G/B': ChordShape(
        chordName: 'G/B',
        fretPositions: [-1, 2, 0, 0, 3, 3], // x20033
      ),
    };

    return commonChords[chordName];
  }
}