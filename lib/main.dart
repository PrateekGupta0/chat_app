import 'package:chat_app_version1/screens/chat_screen.dart';
import 'package:chat_app_version1/screens/login_screen.dart';
import 'package:chat_app_version1/screens/registration_screen.dart';
import 'package:chat_app_version1/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id :(context) =>WelcomeScreen(),
        LoginScreen.id:(context) =>LoginScreen(),
        RegistrationScreen.id:(context) =>RegistrationScreen(),
        ChatScreen.id:(context) =>ChatScreen(),
      },


    );
  }
}


