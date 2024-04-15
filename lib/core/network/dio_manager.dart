import 'package:dio/dio.dart';

/// Singleton class for managing Dio HTTP client instances.
///
/// This class provides a singleton instance of the Dio HTTP client for making API requests.
class DioManager {
  static DioManager? _instance;
  
  /// Retrieves the singleton instance of DioManager.
  static DioManager get instance {
    if (_instance != null) return _instance!;
    _instance = DioManager._init();
    return _instance!;
  }

  /// Base URL for the API.
  final String _baseUrl = 'https://fakestoreapi.com/';

  /// Dio HTTP client instance.
  late final Dio dio;

  /// Initializes the Dio HTTP client instance.
  DioManager._init() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        followRedirects: true,
      ),
    );
  }
}