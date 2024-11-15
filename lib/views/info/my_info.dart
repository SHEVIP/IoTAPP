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
  int permission_id = CommonPreferences.permission_id.value;

  @override
  void initState() {
    super.initState();
    fetchWorkHours();
  }

  fetchWorkHours() async {
    int workerId = CommonPreferences.workerid.value;
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
    final int workerid = CommonPreferences.workerid.value;
    final String workertype = CommonPreferences.workertype.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12.0),
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyInfoDetailPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/worker.png'),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                if (permission_id == 2) ...[
                                  Text(
                                    '工号: $workerid',
                                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    '工种: $workertype',
                                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                        ],
                      ),
                    ),
                  ),
                  if (permission_id == 2)
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    '今日工时',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${todayWorkHours.toStringAsFixed(1)}小时',
                                    style: const TextStyle(fontSize: 16, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey[400],
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    '本月累计工时',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${monthlyWorkHours.toStringAsFixed(1)}小时',
                                    style: const TextStyle(fontSize: 16, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '退出登录',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
    for (var item in items ?? []) {
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
    for (var item in items ?? []) {
      var workHours = WorkHours.fromJson(item).getWorkHours();
      monthlyHours += workHours;
    }
    return monthlyHours;
  } else {
    debugPrint('获取当月工时失败: ${result?.data}');
    return 0.0;
  }
}
