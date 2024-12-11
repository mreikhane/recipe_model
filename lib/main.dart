import 'package:flutter/material.dart';
import 'package:food_receipe/ui/home_screen.dart';
import 'package:food_receipe/ui/login_screen.dart';
import 'package:food_receipe/ui/register_screen.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/home': (context) =>  HomeScreen(),
      },
    );
  }
}
