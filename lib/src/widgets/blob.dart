import 'dart:async';

import 'package:blobs/blobs.dart';
import 'package:blobs/src/config.dart';
import 'package:blobs/src/models.dart';
import 'package:blobs/src/services/blob_generator.dart';
import 'package:blobs/src/widgets/animated_blob.dart';
import 'package:blobs/src/widgets/simple_blob.dart';
import 'package:flutter/material.dart';

/// A widget that renders organic blob shapes with various customization options.
///
/// Blobs are randomly generated organic shapes that can be used for backgrounds,
/// decorations, or visual elements in your Flutter application.
///
/// Four factory constructors are available:
/// - [Blob.random] - Creates a static random blob
/// - [Blob.animatedRandom] - Creates an animated random blob
/// - [Blob.fromID] - Creates a fixed blob from ID(s)
/// - [Blob.animatedFromID] - Creates an animated blob from ID(s)
class Blob extends StatefulWidget {
  /// The size of the blob in logical pixels (width and height).
  final double size;

  /// Whether to show debug visualization of blob construction.
  final bool debug;

  /// Optional styling configuration for the blob appearance.
  final BlobStyles? styles;

  /// Optional controller for programmatic blob shape changes.
  final BlobController? controller;

  /// Optional child widget to display on top of the blob.
  final Widget? child;

  /// Number of edges (nodes) in the blob. Range: 3-300, recommended: 3-20.
  final int? edgesCount;

  /// Minimum growth factor controlling randomness. Range: 2-9.
  final int? minGrowth;

  /// List of blob IDs for fixed shapes. Format: "edgesCount-minGrowth-seed".
  final List<String>? id;

  /// Animation duration for shape transitions.
  final Duration? duration;

  /// Whether to automatically loop through shape changes.
  final bool loop;

  /// Internal flag indicating if this blob is animated.
  final bool isAnimated;

  /// Internal counter for cycling through multiple IDs.
  static int count = 0;

  /// Creates a static blob with random shape.
  ///
  /// Example:
  /// ```dart
  /// Blob.random(
  ///   size: 200,
  ///   edgesCount: 7,
  ///   minGrowth: 4,
  ///   styles: BlobStyles(color: Colors.blue),
  /// )
  /// ```
  const Blob.random({
    required this.size,
    this.edgesCount = BlobConfig.edgesCount,
    this.minGrowth = BlobConfig.minGrowth,
    this.debug = false,
    this.styles,
    this.controller,
    this.child,
    super.key,
  })  : loop = false,
        id = null,
        duration = null,
        isAnimated = false;

  /// Creates an animated blob with random shapes.
  ///
  /// Automatically animates shape transitions. Use [loop] to continuously change.
  ///
  /// Example:
  /// ```dart
  /// Blob.animatedRandom(
  ///   size: 200,
  ///   loop: true,
  ///   duration: Duration(milliseconds: 500),
  /// )
  /// ```
  const Blob.animatedRandom({
    required this.size,
    this.edgesCount = BlobConfig.edgesCount,
    this.minGrowth = BlobConfig.minGrowth,
    this.debug = false,
    this.styles,
    this.duration = const Duration(
      milliseconds: BlobConfig.animDurationMs,
    ),
    this.loop = false,
    this.controller,
    this.child,
    super.key,
  })  : isAnimated = true,
        id = null;

  /// Creates a static blob from one or more fixed IDs.
  ///
  /// IDs ensure the same shape is rendered each time. Generate IDs at
  /// https://blobs.app/ or from [BlobData.id] via controller.
  ///
  /// Example:
  /// ```dart
  /// Blob.fromID(
  ///   size: 200,
  ///   id: ['5-6-43178'],
  /// )
  /// ```
  const Blob.fromID({
    required this.id,
    required this.size,
    this.debug = false,
    this.styles,
    this.controller,
    this.child,
    super.key,
  })  : loop = false,
        edgesCount = null,
        minGrowth = null,
        duration = null,
        isAnimated = false;

  /// Creates an animated blob from fixed IDs.
  ///
  /// With multiple IDs and [loop] enabled, cycles through shapes.
  ///
  /// Example:
  /// ```dart
  /// Blob.animatedFromID(
  ///   size: 200,
  ///   id: ['5-6-111', '7-4-222', '6-8-333'],
  ///   loop: true,
  ///   duration: Duration(seconds: 2),
  /// )
  /// ```
  const Blob.animatedFromID({
    required this.id,
    required this.size,
    this.debug = false,
    this.styles,
    this.duration = const Duration(
      milliseconds: BlobConfig.animDurationMs,
    ),
    this.loop = false,
    this.controller,
    this.child,
    super.key,
  })  : isAnimated = true,
        edgesCount = null,
        minGrowth = null;

  @override
  _BlobState createState() => _BlobState();

  BlobData _randomBlobData() {
    String? randomID = (id == null || id!.isEmpty) ? null : _randomID();
    return BlobGenerator(
      edgesCount: edgesCount,
      minGrowth: minGrowth,
      size: Size(size, size),
      id: randomID,
    ).generate();
  }

  String _randomID() {
    Blob.count++;
    if (id!.length == 1) return id![0];
    return id![Blob.count % id!.length];
  }
}

class _BlobState extends State<Blob> {
  BlobData? blobData;
  BlobData? fromBlobData;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _updateBlob();
    if (widget.loop) {
      timer = Timer.periodic(
        Duration(milliseconds: widget.duration!.inMilliseconds),
        (_) => _updateBlob(),
      );
    } else if (widget.controller != null) {
      widget.controller!.onChange(_updateBlob);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimated) {
      return SimpleBlob(
        blobData: blobData!,
        size: widget.size,
        styles: widget.styles,
        debug: widget.debug,
        child: widget.child,
      );
    }
    return AnimatedBlob(
      fromBlobData: fromBlobData,
      toBlobData: blobData!,
      size: widget.size,
      styles: widget.styles,
      debug: widget.debug,
      duration: widget.duration,
      child: widget.child,
    );
  }

  BlobData _updateBlob() {
    if (widget.isAnimated) {
      fromBlobData = blobData;
    }
    blobData = widget._randomBlobData();
    setState(() {});
    return blobData!;
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    if (widget.controller != null) widget.controller!.dispose();
    super.dispose();
  }
}
