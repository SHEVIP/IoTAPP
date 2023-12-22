import 'package:flutter/material.dart';
import 'package:untitled/components/info/message_scroll.dart';
import 'package:untitled/views/info/my_info_detail_page.dart';
import '../../components/rank_page.dart';
import 'work_hours_details_page.dart';

class MyInfoPage extends StatelessWidget {
  const MyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyInfoDetailPage()));
            },
            child: Container(
              height: 150.0,
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://hbimg.b0.upaiyun.com/dd0b6ebc62b4616d01949f867e5dfd4dc904913c4b23e-AKkABT_fw658'),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('张三', style: TextStyle(fontSize: 24)),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text('工号: 110346920'),
                              SizedBox(width: 10.0),
                              Text('高级车工'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                  SizedBox(width: 20.0),
                ],
              ),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    children: [
                      Text(
                        '今日工时',
                        style: TextStyle(fontSize: 22), // 调整字体大小
                      ),
                      Text(
                        '6小时',
                        style: TextStyle(fontSize: 14), // 调整字体大小
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WorkHoursDetailsPage()),
                      );
                    },
                    child: const Column(
                      children: [
                        Text(
                          '本月累计工时',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          '80小时',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RankPage()),
              );
            },
            child: Container(
              height: 60.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('工时排行榜', style: TextStyle(fontSize: 16)),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          const MessageScroll(),
        ],
      ),
    );
  }
}
