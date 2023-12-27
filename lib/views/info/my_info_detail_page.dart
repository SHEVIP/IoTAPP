import 'package:flutter/material.dart';

class MyInfoDetailPage extends StatelessWidget {
  const MyInfoDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('头像'),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://hbimg.b0.upaiyun.com/dd0b6ebc62b4616d01949f867e5dfd4dc904913c4b23e-AKkABT_fw658'),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              // 点击后的行为
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('姓名'),
            subtitle: const Text('张三'),
            onTap: () {
              // 点击后的行为
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('工号'),
            subtitle: const Text('110346920'),
            onTap: () {
              // 点击后的行为
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('更多信息'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 点击后的行为
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
