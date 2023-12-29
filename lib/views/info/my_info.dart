import 'package:flutter/material.dart';
import 'package:untitled/components/info/message_scroll.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:untitled/views/info/my_info_detail_page.dart';
import 'work_hours_details_page.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:untitled/utils/network_util.dart';
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
                          Text(name, style: TextStyle(fontSize: 24)),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text('工号: $workerid'),
                              SizedBox(width: 10.0),
                              Text('工种: $workertype'),
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
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        '今日工时',
                        style: TextStyle(fontSize: 22), // 调整字体大小
                      ),
                      Text(
                        '${todayWorkHours.toStringAsFixed(1)}小时',
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
                    child:  Column(
                      children: [
                        const Text(
                          '本月累计工时',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          '${monthlyWorkHours.toStringAsFixed(1)}小时',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const RankPage()),
          //     );
          //   },
          //   child: Container(
          //     height: 60.0,
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          //     child: const Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text('工时排行榜', style: TextStyle(fontSize: 16)),
          //         Icon(Icons.arrow_forward_ios, size: 16),
          //       ],
          //     ),
          //   ),
          // ),
          const MessageScroll(),
        ],
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