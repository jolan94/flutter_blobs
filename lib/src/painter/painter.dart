import 'package:blobs/src/models.dart';
import 'package:blobs/src/painter/tools.dart';
import 'package:flutter/material.dart';

/// Custom painter for rendering blob shapes.
///
/// This painter draws the blob path to the canvas and optionally
/// shows debug visualization of the blob's construction geometry.
class BlobPainter extends CustomPainter {
  /// The blob data containing the path and point information.
  final BlobData blobData;

  /// Whether to show debug visualization (circles, lines, points).
  final bool debug;

  /// Optional styling configuration for the blob.
  final BlobStyles? styles;

  /// Creates a [BlobPainter] with the given parameters.
  const BlobPainter({
    required this.blobData,
    this.styles,
    this.debug = false,
  });

  @override
  void paint(Canvas c, Size s) {
    drawBlob(c, blobData.path!, styles);
    if (debug) {
      circle(c, s, s.width / 2); // outer circle
      circle(c, s, blobData.points!.innerRad!); // inner circle
      point(c, Offset(s.width / 2, s.height / 2)); // center point
      final originPoints = blobData.points!.originPoints!;
      final destPoints = blobData.points!.destPoints;
      for (var i = 0; i < originPoints.length; i++) {
        drawLines(c, originPoints[i], destPoints![i]);
      }
    }
  }

  /// Draws debug lines connecting blob points.
  void drawLines(Canvas c, Offset p0, Offset p1) {
    point(c, p0);
    point(c, p1);
    line(c, p0, p1);
  }

  @override
  bool shouldRepaint(covariant BlobPainter oldDelegate) {
    return oldDelegate.blobData.id != blobData.id ||
        oldDelegate.styles != styles ||
        oldDelegate.debug != debug;
  }
}
