import 'package:flutter/material.dart';
import 'package:untitled/views/moments/moments_page.dart';
import 'package:untitled/views/board_page.dart';
import 'package:untitled/views/info/my_info.dart';
import 'package:untitled/views/work_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:untitled/model/message.dart' as myMessage;
import 'package:untitled/utils/network_util.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  static const List _widgetOptions = [
    WorkPage(),
    BoardPage(),
    MomentsPage(),
    MyInfoPage()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int unreadMessages = 0; // 未读消息数
  Timer? messagePollingTimer;
  List<myMessage.Message> messages = []; // 存储消息的列表
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 监听应用生命周期
    _initializeNotifications(); // 初始化通知服务
    startMessagePolling(); // 登录成功后启动轮询
  }

  @override
  void dispose() {
    messagePollingTimer?.cancel(); // 页面销毁时停止轮询
    WidgetsBinding.instance.removeObserver(this); // 取消生命周期监听
    super.dispose();
  }

  // 初始化通知插件
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // 使用你的应用的图标

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 显示本地通知
  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your_channel_id', 'your_channel_name',
        importance: Importance.max, priority: Priority.high, showWhen: false);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // 通知ID
      '新消息提醒', // 通知标题
      message, // 通知正文
      platformChannelSpecifics, // 通知配置
      payload: 'item x', // 负载（可选）
    );
  }

  // 启动消息轮询
  void startMessagePolling() {
    messagePollingTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await fetchMessages(); // 使用你已经实现的消息请求方法
    });
  }

  // 更新未读消息数量
  void updateUnreadMessagesCount() {
    int newUnreadCount = messages.where((message) => !message.isRead).length;
    if (newUnreadCount > unreadMessages) {
      int newMessages = newUnreadCount - unreadMessages;
      // 应用在后台时发本地通知，前台时弹窗
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.paused) {
        _showNotification("您有 $newMessages 条新消息");
      } else {
        showNewMessageDialog(newMessages);
      }
    }
    setState(() {
      unreadMessages = newUnreadCount;
    });
  }

  // 弹窗提醒（前台使用）
  void showNewMessageDialog(int newMessages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新消息提醒'),
          content: Text('您有 $newMessages 条新消息，请及时查看。'),
          actions: [
            TextButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
            ),
          ],
        );
      },
    );
  }

  fetchMessages() async {
    var result = await NetworkUtil.getInstance()
        .get("message/messages?start=1&limit=10");
    debugPrint('请求消息接口返回数据：${result?.data}');

    if (result?.data['status'] == 200) {
      var items = result?.data['data']['item'] as List;
      setState(() {
        messages = items.map((item) => myMessage.Message.fromJson(item)).toList();
      });
    } else {
      debugPrint('请求失败: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '工作台'),
          const BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '看板'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.center_focus_strong), label: '工友圈'),
          BottomNavigationBarItem(
              // icon: Icon(Icons.center_focus_strong), label: '我的'),
              // 使用 Badge 显示未读消息数
              icon: badges.Badge(
                badgeContent: Text(
                  unreadMessages.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                showBadge: unreadMessages > 0, // 当有未读消息时显示 Badge
                child: Icon(Icons.message),
              ),
              label: '我的',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
