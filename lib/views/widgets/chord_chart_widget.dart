import 'package:flutter/material.dart';
import '../../models/song/song.dart';
import '../../models/song/lyric_line.dart';
import '../../models/song/chord_block.dart';
import 'chord_diagram_widget.dart';

class ChordChartWidget extends StatelessWidget {
  final Song song;

  const ChordChartWidget({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render each lyric line
        ...song.lyricLines.map((lyricLine) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildLyricLine(context, lyricLine),
        )),
      ],
    );
  }

  Widget _buildLyricLine(BuildContext context, LyricLine lyricLine) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lyrics
            Text(
              lyricLine.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            
            if (lyricLine.strummingPattern != null) ...[
              const SizedBox(height: 8),
              // Strumming pattern
              Text(
                lyricLine.strummingPattern!,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                  color: Colors.grey[700],
                ),
              ),
            ],

            if (lyricLine.chordBlocks.isNotEmpty) ...[
              const SizedBox(height: 16),
              // Chord blocks in a horizontal scroll
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lyricLine.chordBlocks.length,
                  itemBuilder: (context, index) {
                    final chordBlock = lyricLine.chordBlocks[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildChordBlock(context, chordBlock),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChordBlock(BuildContext context, ChordBlock chordBlock) {
    return Column(
      children: [
        // Chord name
        Text(
          chordBlock.chordName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Chord diagram
        if (chordBlock.chordShape != null)
          ChordDiagramWidget(
            chordShape: chordBlock.chordShape!,
            size: 120,
          )
        else
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'コード図なし',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
      ],
    );
  }
}