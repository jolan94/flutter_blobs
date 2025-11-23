/// Base sealed class for all blob-related exceptions.
///
/// This allows for exhaustive pattern matching when handling errors.
sealed class BlobException implements Exception {
  const BlobException();
}

/// Exception thrown when an invalid blob ID format is provided.
///
/// A valid ID should be in the format: `{edgesCount}-{minGrowth}-{seed}`
/// Example: `5-6-43178`
final class InvalidIDException extends BlobException {
  /// The invalid ID that was provided.
  final String id;

  /// Creates an [InvalidIDException] with the given [id].
  const InvalidIDException(this.id);

  @override
  String toString() {
    return 'InvalidIDException: Invalid blob ID format - "$id". '
        'Expected format: {edgesCount}-{minGrowth}-{seed} (e.g., "5-6-43178")';
  }
}

/// Exception thrown when an invalid edges count is provided.
///
/// The edges count must be greater than 2 and less than or equal to 300.
final class InvalidEdgesCountException extends BlobException {
  /// The invalid edges count that was provided.
  final int count;

  /// Creates an [InvalidEdgesCountException] with the given [count].
  const InvalidEdgesCountException(this.count);

  @override
  String toString() {
    return 'InvalidEdgesCountException: EdgesCount must be between 3 and 300, '
        'but got $count';
  }
}

/// Exception thrown when an invalid growth value is provided.
///
/// The growth value must be between 2 and 9.
final class InvalidGrowthException extends BlobException {
  /// The invalid growth value that was provided.
  final int growth;

  /// Creates an [InvalidGrowthException] with the given [growth].
  const InvalidGrowthException(this.growth);

  @override
  String toString() {
    return 'InvalidGrowthException: Growth value must be between 2 and 9, '
        'but got $growth';
  }
}
