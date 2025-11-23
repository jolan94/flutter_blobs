import 'package:flutter/material.dart';

/// Data class containing all information about a generated blob.
///
/// This includes the blob's dimensions, shape parameters, path data,
/// and SVG export information.
class BlobData {
  /// The minimum growth factor used to generate this blob.
  final int? growth;

  /// The size of the blob in logical pixels.
  final double? size;

  /// The number of edges (nodes) in this blob.
  final int? edges;

  /// The point coordinates (origin and destination) for this blob.
  final BlobPoints? points;

  /// The unique identifier for this blob shape.
  final String? id;

  /// The Flutter [Path] object representing this blob.
  final Path? path;

  /// The SVG path string for exporting this blob.
  final String? svgPath;

  /// The Bezier curve data for this blob.
  final BlobCurves? curves;

  /// Creates a [BlobData] instance with the given parameters.
  BlobData({
    this.growth,
    this.size,
    this.edges,
    this.points,
    this.id,
    this.path,
    this.svgPath,
    this.curves,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlobData &&
          runtimeType == other.runtimeType &&
          growth == other.growth &&
          size == other.size &&
          edges == other.edges &&
          id == other.id &&
          svgPath == other.svgPath;

  @override
  int get hashCode =>
      growth.hashCode ^
      size.hashCode ^
      edges.hashCode ^
      id.hashCode ^
      svgPath.hashCode;
}

class BlobCurves {
  final Offset start;
  final List<List<double>> curves;
  final List<Offset> breakpoints;
  BlobCurves(this.start, this.curves, this.breakpoints);
}

enum BlobFillType { fill, stroke }

/// Styling configuration for blob rendering.
class BlobStyles {
  /// The solid color to fill the blob. Overridden by [gradient] if provided.
  final Color? color;

  /// The gradient shader to fill the blob. Takes precedence over [color].
  final Shader? gradient;

  /// The width of the stroke when [fillType] is [BlobFillType.stroke].
  final int? strokeWidth;

  /// Whether to fill or stroke the blob shape.
  final BlobFillType? fillType;

  /// Creates a [BlobStyles] configuration.
  const BlobStyles({
    this.color,
    this.gradient,
    this.fillType,
    this.strokeWidth,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlobStyles &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          gradient == other.gradient &&
          strokeWidth == other.strokeWidth &&
          fillType == other.fillType;

  @override
  int get hashCode =>
      color.hashCode ^
      gradient.hashCode ^
      strokeWidth.hashCode ^
      fillType.hashCode;
}

class BlobPoints {
  List<Offset>? originPoints;
  List<Offset>? destPoints;
  Offset? center;
  double? innerRad;
  String? id;
  BlobPoints({
    this.originPoints,
    this.destPoints,
    this.center,
    this.id,
    this.innerRad,
  });
}
