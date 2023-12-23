import 'package:flutter/material.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/utils/prefs_util.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _login() async {
    Map params = {};
    params["phone"] = _phoneController.text;
    params["password"] = _passwordController.text;

    var result = await NetworkUtil.getInstance().post("login", params: params);
    if (result?.data['code'] != 200) {
      // 弹出提醒
      const snackBar = SnackBar(
        content: Text('账户或密码错误'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // 保存结果
      CommonPreferences.isLogin.value = true;
      CommonPreferences.phone.value = _phoneController.text;
      CommonPreferences.password.value = _passwordController.text;

      // 弹出提醒
      const snackBar = SnackBar(
        content: Text('登录成功'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // 跳转首页
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              "登陆",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: '请输入手机号',
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '请输入密码(字母与数字)',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _login();
              },
              child: const Text('登录'),
            ),
            ElevatedButton(
              child: const Text('注册账户'),
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ),
      ),
    );
  }
}
