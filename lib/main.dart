import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/Models/cart/cart_model.dart';

import 'package:test/controller/auth_controller.dart';
import 'package:test/views/home_screen.dart';

import 'package:test/views/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CartModelAdapter().typeId)) {
    Hive.registerAdapter(CartModelAdapter());
  }
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 3000,
        splash: CircularProgressIndicator(),
        nextScreen: Root(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'todo list using firebase',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: SplashScreenWidget(),
    );
  }
}

class Root extends StatelessWidget {
  Root({super.key});
  AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("${_authController.user.value}");
      return _authController.user.value == null ? LoginScreen() : HomeScreen();
    });
  }
}
