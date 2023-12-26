import 'package:flutter/material.dart';
import '../../utils/network_util.dart';
import '../../utils/prefs_util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _register() async {
    String username = _usernameController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String repeat_pwd = _repeatPasswordController.text;

    if (phone == '' ||
        username == '' ||
        password == '' ||
        password != repeat_pwd) {
      const snackBar = SnackBar(
        content: Text('输入信息不能为空，两次密码需要相同,请重新输入'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    Map params = Map();
    params["username"] = _usernameController.text;
    params["phone"] = _phoneController.text;
    params["password"] = _passwordController.text;

    var result =
        await NetworkUtil.getInstance().post("register", params: params);
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
        content: Text('注册成功'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // 跳转首页
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '请输入用户名(请使用英文字母、汉字或数字)',
              ),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: '请输入手机号',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '请输入密码(请使用英文字母或数字)',
              ),
            ),
            TextField(
              controller: _repeatPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '请确认密码',
              ),
            ),
            // SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
                await _register();
              },
              child: const Text('确认注册'),
            ),
          ],
        ),
      ),
    );
  }
}
