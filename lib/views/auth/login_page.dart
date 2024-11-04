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
    Map<String, dynamic> params = {
      "user_name": _usernameController.text,
      "password": _passwordController.text,
    };

    var result = await NetworkUtil1.getInstance().post("user/login", params: params);
    if (result?.data['status'] != 200) {
      const snackBar = SnackBar(
        content: Text('账户或密码错误'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      CommonPreferences.isLogin.value = true;
      CommonPreferences.username.value = _usernameController.text;
      CommonPreferences.password.value = _passwordController.text;
      CommonPreferences.workername.value = result?.data['data']['user']['user_name'];
      CommonPreferences.userid.value = 1;
      CommonPreferences.workerid.value = 1;
      CommonPreferences.permission_id.value = result?.data['data']['user']['permission_id'];

      const snackBar = SnackBar(
        content: Text('登录成功'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("用户登录"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "欢迎登录",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 40.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '用户名',
                  prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密码',
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    '登录',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // TextButton(
              //   onPressed: () => Navigator.pushNamed(context, '/register'),
              //   child: const Text(
              //     "没有账户？点击注册",
              //     style: TextStyle(color: Colors.blueAccent, fontSize: 14),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
