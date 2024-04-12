import 'package:flutter/material.dart';
import 'views/auth/view/auth_view.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    theme: ThemeData(),
    home: const AuthView(),
  ));
}