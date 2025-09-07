import 'package:flutter/material.dart';
import '../../models/chord/chord_shape.dart';

class ChordDiagramWidget extends StatelessWidget {
  final ChordShape chordShape;
  final double size;

  const ChordDiagramWidget({
    super.key,
    required this.chordShape,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: ChordDiagramPainter(chordShape),
        size: Size(size, size),
      ),
    );
  }
}

class ChordDiagramPainter extends CustomPainter {
  final ChordShape chordShape;
  static const int numFrets = 4; // Show 4 frets
  static const int numStrings = 6; // 6 guitar strings

  ChordDiagramPainter(this.chordShape);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.5
      ..color = Colors.black;

    final double margin = size.width * 0.15;
    final double diagramWidth = size.width - (margin * 2);
    final double diagramHeight = size.height - (margin * 2);
    
    final double stringSpacing = diagramWidth / (numStrings - 1);
    final double fretSpacing = diagramHeight / numFrets;

    // Draw strings (vertical lines)
    for (int i = 0; i < numStrings; i++) {
      final double x = margin + (i * stringSpacing);
      canvas.drawLine(
        Offset(x, margin),
        Offset(x, margin + diagramHeight),
        paint,
      );
    }

    // Draw frets (horizontal lines)
    for (int i = 0; i <= numFrets; i++) {
      final double y = margin + (i * fretSpacing);
      final strokeWidth = i == 0 ? 3.0 : 1.5; // Nut is thicker
      final fretPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = Colors.black;
      
      canvas.drawLine(
        Offset(margin, y),
        Offset(margin + diagramWidth, y),
        fretPaint,
      );
    }

    // Draw finger positions
    final dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (int stringIndex = 0; stringIndex < chordShape.fretPositions.length && stringIndex < numStrings; stringIndex++) {
      final fretPosition = chordShape.fretPositions[stringIndex];
      
      if (fretPosition > 0) {
        // Calculate position
        final double x = margin + (stringIndex * stringSpacing);
        final double y = margin + ((fretPosition - chordShape.baseFret - 0.5) * fretSpacing);
        
        // Draw finger dot
        if (y >= margin && y <= margin + diagramHeight) {
          canvas.drawCircle(
            Offset(x, y),
            size.width * 0.03,
            dotPaint,
          );
        }
      } else if (fretPosition == 0) {
        // Open string - draw small circle above nut
        final double x = margin + (stringIndex * stringSpacing);
        final double y = margin - (size.height * 0.05);
        
        final openPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
          
        canvas.drawCircle(
          Offset(x, y),
          size.width * 0.02,
          openPaint,
        );
      } else if (fretPosition == -1) {
        // Muted string - draw X above nut
        final double x = margin + (stringIndex * stringSpacing);
        final double y = margin - (size.height * 0.05);
        final double crossSize = size.width * 0.02;
        
        final mutePaint = Paint()
          ..color = Colors.red
          ..strokeWidth = 2;
        
        canvas.drawLine(
          Offset(x - crossSize, y - crossSize),
          Offset(x + crossSize, y + crossSize),
          mutePaint,
        );
        canvas.drawLine(
          Offset(x - crossSize, y + crossSize),
          Offset(x + crossSize, y - crossSize),
          mutePaint,
        );
      }
    }

    // Draw fret number if not starting from 0
    if (chordShape.baseFret > 0) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${chordShape.baseFret + 1}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(margin - textPainter.width - 8, margin + fretSpacing - (textPainter.height / 2)),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}