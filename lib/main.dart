import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signup_firebase_project/login.dart';
import 'package:signup_firebase_project/dataSave.dart';
import 'package:signup_firebase_project/view_model/user_preference/user_preference_view_modal.dart';

import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userPref = UserPreference();
  final stored = await userPref.getUser();
  final hasToken = stored.token != null && stored.token!.isNotEmpty && stored.token != 'null';

  try {
    await Firebase.initializeApp();
  } catch (e) {
    // If Firebase fails to initialize, surface a simple error UI so app doesn't hang on the native splash.
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Firebase initialization error:\n$e', textAlign: TextAlign.center)),
      ),
    ));
    return;
  }

  runApp(MyApp(initialLoggedIn: hasToken));
}

class MyApp extends StatelessWidget {
  final bool initialLoggedIn;
  const MyApp({super.key, required this.initialLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialLoggedIn ? const TasksPage() : login_screen(),
    );
  }
}


