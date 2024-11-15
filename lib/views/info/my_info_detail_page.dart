import 'package:flutter/material.dart';

class MyInfoDetailPage extends StatelessWidget {
  const MyInfoDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '个人信息',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: <Widget>[
            _buildProfileItem(
              context,
              title: '头像',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://hbimg.b0.upaiyun.com/dd0b6ebc62b4616d01949f867e5dfd4dc904913c4b23e-AKkABT_fw658',
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
              onTap: () {},
            ),
            _buildDivider(),
            _buildProfileItem(
              context,
              title: '姓名',
              subtitle: '张三',
              trailing: const Icon(Icons.edit, color: Colors.grey),
              onTap: () {},
            ),
            _buildDivider(),
            _buildProfileItem(
              context,
              title: '工号',
              subtitle: '110346920',
              trailing: const Icon(Icons.edit, color: Colors.grey),
              onTap: () {},
            ),
            _buildDivider(),
            _buildProfileItem(
              context,
              title: '更多信息',
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context,
      {required String title,
        String? subtitle,
        required Widget trailing,
        required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 1,
      ),
    );
  }
}
