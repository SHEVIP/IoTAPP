import 'package:flutter/material.dart';
import 'package:untitled/components/info/message_scroll.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:untitled/views/info/my_info_detail_page.dart';
import 'work_hours_details_page.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:untitled/utils/network_util.dart';
// import 'package:untitled/views/info/wifi_connect.dart';
import 'package:untitled/views/info/esptouch_full.dart';
import '../../model/work_hours.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key? key}) : super(key: key);

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}


class _MyInfoPageState extends State<MyInfoPage> {
  double todayWorkHours = 0.0;
  double monthlyWorkHours = 0.0;

  @override
  void initState() {
    super.initState();
    fetchWorkHours();
  }

  fetchWorkHours() async {
    int workerId = CommonPreferences.workerid.value;
    // 两个方法来获取今日和当月的工时
    var todayHours = await getTodayWorkHours(workerId);
    var monthHours = await getMonthlyWorkHours(workerId);
    setState(() {
      todayWorkHours = todayHours;
      monthlyWorkHours = monthHours;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = CommonPreferences.workername.value;
    final int workerid = CommonPreferences.workerid.value ; // 如果没有值，则返回 'N/A'
    final String workertype = CommonPreferences.workertype.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息', style: TextStyle(fontSize: 26)),
        backgroundColor: Colors.grey[200], // 更改AppBar颜色
      ),
      body: Container(
        color: Colors.grey[200], // 整体背景色设置为浅灰色
        child: ListView(
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
                child:  Row(
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
                            Text(name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26)),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                Text('工号: $workerid', style:TextStyle(color: Colors.blue,fontSize: 18)),
                                SizedBox(width: 20.0),
                                Text('工种: $workertype', style:TextStyle(color: Colors.grey,fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 16),
                    SizedBox(width: 10.0),
                  ],
                ),
              ),
            ),
            // 工时信息部分，为了增加间隔，我们使用Container包裹Column
            Card(
              margin: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0), // 卡片内边距
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, // 平均分布空间
                  children: [
                    // 今日工时部分
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            '今日工时',
                            style: TextStyle(fontSize: 22), // 调整字体大小
                          ),
                          SizedBox(height: 6), // 标题和数字之间的间隙
                          Text(
                            '${todayWorkHours.toStringAsFixed(1)}小时',
                            style: TextStyle(fontSize: 14, color: Colors.green), // 调整字体大小和颜色
                          ),
                        ],
                      ),
                    ),

                    // 垂直分割线
                    Container(
                      height: 60, // 分割线高度
                      width: 3, // 分割线宽度
                      color: Colors.grey[400], // 分割线颜色
                      margin: const EdgeInsets.symmetric(horizontal: 12), // 分割线水平间隙
                    ),

                    // 本月累计工时部分
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WorkHoursDetailsPage()),
                          );
                        },
                        child:  Column(
                          children: [
                            const Text(
                              '本月累计工时',
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              '${monthlyWorkHours.toStringAsFixed(1)}小时',
                              style: TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => esptouch()),
                  ),
                  child: const Text('为网联设备配对WIFI', style: TextStyle(fontSize: 18),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // 设置按钮背景颜色为淡蓝色
                    onPrimary: Colors.lightBlue[500], // 设置文字颜色为白色
                    elevation: 2, // 设置阴影
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 设置按钮的圆角
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15), // 设置内边距
                  ),
                ),
              ),
            ),

            const MessageScroll(),
            ElevatedButton(
              child: const Text('退出登录'),
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            // 如果需要在列表底部增加灰色背景，可以添加额外的空白Container
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   color: Colors.grey[200], // 底部灰色背景
            // ),
          ],
        ),
      ),
    );
  }
}

Future<double> getTodayWorkHours(int workerId) async {
  DateTime today = DateTime.now();
  String formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  var result = await NetworkUtil.getInstance().get(
      "workerAttendance/workerAttendances?start=1&limit=10&worker_id=$workerId&date=$formattedDate");
  debugPrint('今日工时数据：${result?.data}');

  if (result?.data['status'] == 200) {
    var items = result?.data['data']['item'];
    double todayHours = 0.0;
    for (var item in items) {
      var workHours = WorkHours.fromJson(item).getWorkHours();
      todayHours += workHours;
    }
    return todayHours;
  } else {
    debugPrint('获取今日工时失败: ${result?.data}');
    return 0.0;
  }
}

Future<double> getMonthlyWorkHours(int workerId) async {
  DateTime now = DateTime.now();
  DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
  String formattedStartDate = "${firstDayOfMonth.year}-${firstDayOfMonth.month.toString().padLeft(2, '0')}";

  var result = await NetworkUtil.getInstance().get(
      "workerAttendance/workerAttendances?start=1&limit=31&worker_id=$workerId&date=$formattedStartDate");
  debugPrint('当月工时数据：${result?.data}');

  if (result?.data['status'] == 200) {
    var items = result?.data['data']['item'];
    double monthlyHours = 0.0;
    for (var item in items) {
      var workHours = WorkHours.fromJson(item).getWorkHours();
      monthlyHours += workHours;
    }
    return monthlyHours;
  } else {
    debugPrint('获取当月工时失败: ${result?.data}');
    return 0.0;
  }
}

