import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/network/dio_manager.dart';
import '../../../core/services/auth/mock_auth_service.dart';
import '../../../core/services/service_state.dart';
import '../../home/view/home_view.dart';
import '../viewModel/auth_view_model.dart';


class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final AuthViewModel _authViewModel = AuthViewModel(MockAuthService(DioManager.instance.dio));

  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  
  String _signInEmail = '';
  String _signInPassword = '';

  String _signUpName = '';
  String _signUpEmail = '';
  String _signUpPassword = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              _buildSignInPage(),
              _buildSignUpPage(),
            ],
          ),
        ),
        _buildAuthViewStates()
      ],
    );
  }

  Widget _buildSignInPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _signInFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const ValueKey('signInEmail'),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                initialValue: _signInEmail,
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Enter your email.';
                  }
                  if(!EmailValidator.validate(value)) {
                    return 'Enter a valid email.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _signInEmail = value.trim();
                  });
                },
              ),
              TextFormField(
                key: const ValueKey('signInPassword'),
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                initialValue: _signInPassword,
                validator: (value) {
                  if (value!.isEmpty || value.length < 7) {
                    return 'The password must be at least 7 characters.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _signInPassword = value.trim();
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitSignIn(context),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _signUpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const ValueKey('signUpName'),
                decoration: const InputDecoration(labelText: 'Name'),
                initialValue: _signUpName,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _signUpName = value.trim();
                  });
                },
              ),
              TextFormField(
                key: const ValueKey('signUpEmail'),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                initialValue: _signUpEmail,
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Enter your email.';
                  }
                  if(!EmailValidator.validate(value)) {
                    return 'Enter a valid email.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _signUpEmail = value.trim();
                  });
                },
              ),
              TextFormField(
                key: const ValueKey('signUpPassword'),
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                initialValue: _signUpPassword,
                validator: (value) {
                  if (value!.isEmpty || value.length < 7) {
                    return 'The password must be at least 7 characters.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _signUpPassword = value.trim();
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitSignUp(context),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Observer _buildAuthViewStates() {
    return Observer(
      builder: (_) {
        if(_authViewModel.user != null){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()), // Reemplaza NewView con el nombre de tu vista
            );
          });
          return const SizedBox.shrink();
        }
        
        switch (_authViewModel.serviceState) {
          case ServiceState.loading:
            return const Center(
              child: CircularProgressIndicator()
            );
          case ServiceState.success || ServiceState.normal:
            return const SizedBox.shrink();
          case ServiceState.error:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text(_authViewModel.errorMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _authViewModel.serviceState = ServiceState.normal;
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            });
            return const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _submitSignIn(BuildContext context) async {
    final isValid = _signInFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    await _authViewModel.signInService(_signInEmail, _signInPassword);

    if(_authViewModel.serviceState == ServiceState.success && context.mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }

  Future<void> _submitSignUp(BuildContext context) async {
    final isValid = _signUpFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    await _authViewModel.signUpService(_signUpName, _signUpEmail, _signUpPassword);

    if(_authViewModel.serviceState == ServiceState.success && context.mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }
}