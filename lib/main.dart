import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/auth_controller.dart';
import 'models/user_model.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/login_screen.dart';
import 'ui/pages/signup_screen.dart';
import 'ui/pages/interview_screen.dart';
import 'ui/pages/result_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox<UserModel>('users');
  await Hive.openBox<String>('session');

  final AuthController authController = Get.put(AuthController());

  runApp(
    NeuroTrainerApp(
      initialRoute: authController.currentUser.value == null
          ? '/login'
          : '/home',
    ),
  );
}

class NeuroTrainerApp extends StatelessWidget {
  final String initialRoute;

  const NeuroTrainerApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Interview App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignupPage()),
        GetPage(name: '/home', page: () => const InterviewHomePage()),
        GetPage(name: '/interview', page: () => InterviewScreen()),
        GetPage(name: '/result', page: () => ResultScreen()),
      ],
    );
  }
}
