import 'package:flutter/material.dart';
import 'package:untitled/views/home_page.dart';
import 'package:untitled/views/login_page.dart';
import 'package:untitled/views/register_page.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:untitled/views/test_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化Prefs
  await CommonPreferences.init();

  // Debug模式的print
  debugPrint = (message, {wrapWidth}) => print(message);

  // 挂载页面
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(title: ""),
        '/page': (context) => const PageViewSwiperText(),
      },
    );
  }
}

