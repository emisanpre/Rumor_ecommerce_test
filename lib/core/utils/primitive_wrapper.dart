/// Generic class for wrapping primitive values.
///
/// This class provides a wrapper around primitive values to facilitate passing them by reference.
class PrimitiveWrapper<T> {
  /// Wrapped value of type T.
  T value;

  /// Constructs a PrimitiveWrapper with the provided value.
  ///
  /// [value]: Initial value to wrap.
  PrimitiveWrapper(this.value);
}
