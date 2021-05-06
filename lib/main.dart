import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_models/screens/home_screen.dart';
import 'package:flutter_app_models/screens/nav_screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.black)
  );
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(ProviderScope(child: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        errorColor: Colors.black,
            primaryColor: Colors.brown,
      ),
      home: KeyboardDismissOnTap(
          child: HomeScreen()
      ),
      routes: {
        NavScreen.navRoute: (context) => NavScreen(),
      },
    );
  }
}

