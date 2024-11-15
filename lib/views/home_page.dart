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
import 'package:untitled/views/factory_info_page.dart'; // 导入新页面
import 'package:untitled/views/device_manager_page.dart'; // 导入新页面
import 'package:untitled/views/video_monitoring_page.dart';

import '../utils/prefs_util.dart'; // 导入新页面

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 1;
  String userRole = "employee"; // 权限变量，"employee" 表示员工，"manager" 表示经理
  int permission_id = CommonPreferences.permission_id.value;


  List<Widget> _widgetOptions = []; // 设置默认值为空列表
  List<BottomNavigationBarItem> _navItems = []; // 设置默认值为空列表

  // static const List _widgetOptions = [
  //   BoardPage(),
  //   WorkPage(),
  //   // MomentsPage(),
  //   MyInfoPage(),
  // ];

  void _initializeRoleBasedContent() {
    if (permission_id == 2 || permission_id == 3) {
      _widgetOptions = [
        const BoardPage(), // 生产信息页面
        const WorkPage(), // 异常处理页面
        const MyInfoPage(), // 我的页面
      ];
      _navItems = [
        const BottomNavigationBarItem(icon: Icon(Icons.production_quantity_limits), label: '生产信息'),
        const BottomNavigationBarItem(icon: Icon(Icons.warning), label: '异常处理'),
        BottomNavigationBarItem(
          icon: badges.Badge(
            badgeContent: Text(
              unreadMessages.toString(),
              style: TextStyle(color: Colors.white),
            ),
            showBadge: unreadMessages > 0,
            child: Icon(Icons.person),
          ),
          label: '我的',
        ),
      ];
    } else if (permission_id == 1){
      _widgetOptions = [
        const FactoryManagementPage(), // 工厂状态页面
        const DeviceManagertPage(), // 设备信息页面
        const VideoMonitoringPage(), // 设备信息页面
        const MyInfoPage(), // 我的页面
      ];
      _navItems = [
        const BottomNavigationBarItem(icon: Icon(Icons.factory), label: '工厂信息'),
        const BottomNavigationBarItem(icon: Icon(Icons.devices), label: '设备信息'),
        const BottomNavigationBarItem(icon: Icon(Icons.video_call), label: '视频监控'),
        BottomNavigationBarItem(
          icon: badges.Badge(
            badgeContent: Text(
              unreadMessages.toString(),
              style: TextStyle(color: Colors.white),
            ),
            showBadge: unreadMessages > 0,
            child: Icon(Icons.person),
          ),
          label: '我的',
        ),
      ];
    }
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 如果点击的是 "我的" Tab，则清除未读消息数
      // if (index == 2 || index == 3) { // "我的" Tab 的索引为 3
      //   unreadMessages = 0; // 清除未读消息数
      // }
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
    _initializeRoleBasedContent();
    WidgetsBinding.instance.addObserver(this); // 监听应用生命周期
    _initializeNotifications(); // 初始化通知服务
    // startMessagePolling(); // 登录成功后启动轮询
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
      updateUnreadMessagesCount();
    });
  }

  // 更新未读消息数量
  void updateUnreadMessagesCount() {
    int newUnreadCount = messages.where((message) => !message.isRead).length;
    // int newUnreadCount = 11;
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: _widgetOptions.elementAt(_selectedIndex),
  //     bottomNavigationBar: BottomNavigationBar(
  //       type: BottomNavigationBarType.fixed,
  //       items: <BottomNavigationBarItem>[
  //         // const BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '工作台'),
  //         // const BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '看板'),
  //         // const BottomNavigationBarItem(
  //         //     icon: Icon(Icons.center_focus_strong), label: '工友圈'),
  //         const BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '生产信息'),
  //         const BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '异常处理'),
  //         BottomNavigationBarItem(
  //             // icon: Icon(Icons.center_focus_strong), label: '我的'),
  //             // 使用 Badge 显示未读消息数
  //             icon: badges.Badge(
  //               badgeContent: Text(
  //                 unreadMessages.toString(),
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //               showBadge: unreadMessages > 0, // 当有未读消息时显示 Badge
  //               child: Icon(Icons.message),
  //             ),
  //             label: '我的',
  //         )
  //       ],
  //       currentIndex: _selectedIndex,
  //       selectedItemColor: Colors.amber[800],
  //       onTap: _onItemTapped,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // 确保 _widgetOptions 已根据 userRole 初始化
    if (_widgetOptions.isEmpty) {
      _initializeRoleBasedContent();
    }
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
