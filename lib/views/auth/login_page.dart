import 'package:flutter/material.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/utils/network_util1.dart';
import 'package:untitled/utils/prefs_util.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _login() async {
    Map<String, dynamic> params = Map();
    params["user_name"] = _usernameController.text;
    params["password"] = _passwordController.text;
    CommonPreferences.isLogin.value = true;
    CommonPreferences.workername.value = "徐志强";
    CommonPreferences.userid.value = 1;
    CommonPreferences.workerid.value = 1;
    CommonPreferences.workertype.value = "worker1";

    // 弹出提醒
    // const snackBar = SnackBar(
    //   content: Text('登录成功'),
    //   duration: Duration(seconds: 1),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // 跳转首页
    //Navigator.pushReplacementNamed(context, '/home');
    var result = await NetworkUtil1.getInstance().post("user/login", params: params);
    print('${result?.data}');
    if (result?.data['status'] != 200) {
      // 弹出提醒
      const snackBar = SnackBar(
        content: Text('账户或密码错误'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // 保存结果
      CommonPreferences.isLogin.value = true;
      CommonPreferences.username.value = _usernameController.text;
      CommonPreferences.password.value = _passwordController.text;

      CommonPreferences.workername.value = result?.data['data']['user']['user_name'];
      //CommonPreferences.userid.value = result?.data['data']['user']['user_id'];
      CommonPreferences.userid.value = 1;
      // api未提供worker_id
      CommonPreferences.workerid.value = 1;

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
              "登录",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '请输入用户名',
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
