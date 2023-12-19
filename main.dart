import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'myinfo.dart';
import 'WorkHoursDetailsPage.dart';


void main() {
  initializeDateFormatting().then((_)  =>  runApp(MyApp()))  ;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的页面'),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              // 在这里定义点击事件，例如跳转到另一个页面
              Navigator.push(context, MaterialPageRoute(builder: (context) => Myinfo()));
            },
            child: Container(
              height: 150.0, // 调整高度以适应额外内容
              padding: EdgeInsets.all(10.0), // 添加一些内边距
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10.0), // 添加一些间距
                  CircleAvatar(
                    radius: 50,
                    // 在这里插入头像图片
                    backgroundImage: NetworkImage('https://hbimg.b0.upaiyun.com/dd0b6ebc62b4616d01949f867e5dfd4dc904913c4b23e-AKkABT_fw658'),
                  ),
                  SizedBox(width: 10.0), // 添加一些间距
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('张三', style: TextStyle(fontSize: 24)),
                          SizedBox(height: 10.0), // 添加一些间距
                          Row(
                            children: [
                              Text('工号: 110346920'),
                              SizedBox(width: 10.0), // 添加一些间距
                              Text('高级车工'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //小箭头离右侧保持一定距离
                  Icon(Icons.arrow_forward_ios), // 添加小箭头
                  SizedBox(width: 20.0),
                ],
              ),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                        MaterialPageRoute(builder: (context) => WorkHoursDetailsPage()),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          '本月累计工时',
                          style: TextStyle(fontSize: 22), // 调整字体大小
                        ),
                        Text(
                          '80小时',
                          style: TextStyle(fontSize: 14), // 调整字体大小
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          MyMessagesWidget(),
        ],
      ),
    );
  }
}

class MyMessagesWidget extends StatefulWidget {
  @override
  _MyMessagesWidgetState createState() => _MyMessagesWidgetState();
}

class _MyMessagesWidgetState extends State<MyMessagesWidget> {
  // 初始化一些随机消息数据
  final List<String> messages = List.generate(10, (index) => '设备 $index 出现异常，请您检查');
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('我的消息'),
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(), // 禁止ListView滚动
            shrinkWrap: true, // 使ListView占用的空间大小只有它的子项目所需要的大小
            itemCount: isExpanded ? messages.length : 0, // 展开全部，或者只显示3条消息
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(messages[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// class WorkHoursDetailsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('工时详情'),
//       ),
//       body: Center(
//         child: Text('这里显示工时的详细信息'),
//       ),
//     );
//   }
// }

// class Myinfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('个人信息'),
//       ),
//       body: ListView(
//         children: [
//           Text('名字'),
//           Text('个性签名'),
//         ],
//       ),
//     );
//   }
// }
