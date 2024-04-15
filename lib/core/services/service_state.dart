/// Enum representing the state of a service operation.
enum ServiceState {
  /// Indicates that the service operation is in progress (loading).
  loading,

  /// Indicates that an error occurred during the service operation.
  error,

  /// Indicates that the service operation was successful.
  success,

  /// Indicates a normal state with no ongoing service operation.
  normal,
}