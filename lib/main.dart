import 'package:flutter/material.dart';
import 'views/auth/view/auth_view.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.lightBlue,
      highlightColor: Colors.blueAccent,
      appBarTheme: const AppBarTheme(
        color: Colors.lightBlue,
        titleTextStyle:  TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        )
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.lightBlue,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        surface: Colors.white,
        background: Colors.white,
      ),
    ),
    home: const AuthView(),
  ));
}