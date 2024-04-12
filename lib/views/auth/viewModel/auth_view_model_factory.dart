import '../../../core/network/dio_manager.dart';
import '../../../core/services/auth/mock_auth_service.dart';
import 'auth_view_model.dart';

class AuthViewModelFactory {
  static AuthViewModel? _instance;

  static AuthViewModel getInstance() {
    _instance ??= AuthViewModel(MockAuthService(DioManager.instance.dio));
    return _instance!;
  }
}