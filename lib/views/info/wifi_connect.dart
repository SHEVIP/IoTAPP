import 'dart:io';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';

class WifiConnectPage extends StatefulWidget {
  const WifiConnectPage({Key? key}) : super(key: key);

  @override
  _WifiConnectPageState createState() => _WifiConnectPageState();
}

class _WifiConnectPageState extends State<WifiConnectPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _wifiIp;    // 用于存储获取的WiFi IP地址
  String? _wifiSSID;  // 用于存储获取的WiFi SSID

  @override
  void initState() {
    super.initState();
    _getWifiIp();
    _getWifiInfo();
  }

  Future<void> _getWifiIp() async {
    final info = NetworkInfo();
    var wifiIp = await info.getWifiIP();
    setState(() {
      _wifiIp = wifiIp;
    });
    print("Wi-Fi IP: $_wifiIp");
  }
  Future<void> _getWifiInfo() async {
    final info = NetworkInfo();
    var wifiIp = await info.getWifiIP();
    var wifiSSID = await info.getWifiName();  // 获取WiFi名称
    setState(() {
      _wifiIp = wifiIp;
      _wifiSSID = wifiSSID;  // 存储SSID
    });
  }

  void _copyToClipboard() {
    // 提供一个默认值以防 `_wifiSSID` 是 `null`
    Clipboard.setData(ClipboardData(text: _wifiSSID ?? "未连接"));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SSID已复制到剪贴板'),
      ),
    );
  }


  void _sendWifiCredentials() async {
    if (_ssidController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('错误'),
          content: const Text('SSID和密码不能为空！'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('好的'),
            ),
          ],
        ),
      );
      return;
    }

    final String ssid = _ssidController.text;
    final String password = _passwordController.text;

    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      final message = 'SSID:$ssid;PASSWORD:$password;';
      List<int> data = message.codeUnits;
      socket.send(data, InternetAddress(_wifiIp!), 80); // 使用获取的IP地址发送消息
      print('Credentials sent: $message');
      socket.close();
    }).catchError((e) {
      print('Error sending credentials: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('连接WiFi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '当前SSID: ${_wifiSSID ?? "未连接"}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: _copyToClipboard,
                ),
              ],
            ),
            TextField(
              controller: _ssidController,
              decoration: const InputDecoration(
                labelText: 'WiFi SSID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'WiFi 密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: _sendWifiCredentials,
                  child: const Text('发送WiFi凭证'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[200], // 按钮的背景颜色设置为淡蓝色
                    onPrimary: Colors.white, // 文字颜色
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
