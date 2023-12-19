import 'package:flutter/material.dart';
class Myinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人信息'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('头像'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://hbimg.b0.upaiyun.com/dd0b6ebc62b4616d01949f867e5dfd4dc904913c4b23e-AKkABT_fw658'), // 替换为你的图片路径
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              // 点击后的行为
            },
          ),
          Divider(),
          ListTile(
            title: Text('姓名'),
            subtitle: Text('张三'),
            onTap: () {
              // 点击后的行为
            },
          ),
          Divider(),
          ListTile(
            title: Text('工号'),
            subtitle: Text('110346920'),
            onTap: () {
              // 点击后的行为
            },
          ),
          Divider(),
          ListTile(
            title: Text('更多信息'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 点击后的行为
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
