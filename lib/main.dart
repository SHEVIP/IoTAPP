import 'package:flutter/material.dart';
import 'package:untitled/views/home_page.dart';
import 'package:untitled/views/auth/login_page.dart';
import 'package:untitled/views/auth/register_page.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化Prefs
  await CommonPreferences.init();

  // Debug模式的print
  debugPrint = (message, {wrapWidth}) => print(message);

  // 使用intl库 允许将字符串转为时间
  await initializeDateFormatting();

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

