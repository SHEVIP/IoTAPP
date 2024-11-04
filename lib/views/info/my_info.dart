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
  int permission_id = CommonPreferences.permission_id.value;

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

  // @override
  // Widget build(BuildContext context) {
  //   final String name = CommonPreferences.workername.value;
  //   final int workerid = CommonPreferences.workerid.value;
  //   final String workertype = CommonPreferences.workertype.value;
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('个人信息'),
  //       backgroundColor: Colors.grey[200],
  //       centerTitle: true,
  //     ),
  //     body: Container(
  //       color: Colors.grey[200],
  //       child: Column(
  //         children: <Widget>[
  //           Expanded(
  //             child: ListView(
  //               children: <Widget>[
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => const MyInfoDetailPage()));
  //                   },
  //                   child: Container(
  //                     height: 150.0,
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Row(
  //                       children: <Widget>[
  //                         const SizedBox(width: 10.0),
  //                         const CircleAvatar(
  //                           radius: 50,
  //                           backgroundImage: AssetImage('assets/images/worker.png'),
  //                         ),
  //                         const SizedBox(width: 10.0),
  //                         Expanded(
  //                           child: Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Text(
  //                                   name,
  //                                   style: const TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 26,
  //                                   ),
  //                                 ),
  //                                 const SizedBox(height: 16.0),
  //                                 Row(
  //                                   children: [
  //                                     Text(
  //                                       '工号: $workerid',
  //                                       style: const TextStyle(color: Colors.blue, fontSize: 18),
  //                                     ),
  //                                     const SizedBox(width: 20.0),
  //                                     Text(
  //                                       '工种: $workertype',
  //                                       style: const TextStyle(color: Colors.grey, fontSize: 18),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
  //                         const SizedBox(width: 10.0),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Card(
  //                   margin: const EdgeInsets.all(12.0),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(12.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       children: [
  //                         Expanded(
  //                           child: Column(
  //                             children: [
  //                               const Text(
  //                                 '今日工时',
  //                                 style: TextStyle(fontSize: 22),
  //                               ),
  //                               const SizedBox(height: 6),
  //                               Text(
  //                                 '${todayWorkHours.toStringAsFixed(1)}小时',
  //                                 style: const TextStyle(fontSize: 14, color: Colors.green),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Container(
  //                           height: 60,
  //                           width: 3,
  //                           color: Colors.grey[400],
  //                           margin: const EdgeInsets.symmetric(horizontal: 12),
  //                         ),
  //                         Expanded(
  //                           child: Column(
  //                             children: [
  //                               const Text(
  //                                 '本月累计工时',
  //                                 style: TextStyle(fontSize: 22),
  //                               ),
  //                               const SizedBox(height: 6),
  //                               Text(
  //                                 '${monthlyWorkHours.toStringAsFixed(1)}小时',
  //                                 style: const TextStyle(fontSize: 14, color: Colors.green),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 // Center(
  //                 //   child: Container(
  //                 //     width: MediaQuery.of(context).size.width * 0.6,
  //                 //     child: ElevatedButton(
  //                 //       onPressed: () => Navigator.push(
  //                 //         context,
  //                 //         MaterialPageRoute(builder: (context) => esptouch()),
  //                 //       ),
  //                 //       child: const Text('为网联设备配对WIFI', style: TextStyle(fontSize: 18)),
  //                 //       style: ElevatedButton.styleFrom(
  //                 //         primary: Colors.white,
  //                 //         onPrimary: Colors.lightBlue[500],
  //                 //         elevation: 2,
  //                 //         shape: RoundedRectangleBorder(
  //                 //           borderRadius: BorderRadius.circular(8),
  //                 //         ),
  //                 //         padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
  //                 //       ),
  //                 //     ),
  //                 //   ),
  //                 // ),
  //               ],
  //             ),
  //           ),
  //           // 将“退出登录”按钮固定在底部
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: ElevatedButton(
  //               onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
  //               style: ElevatedButton.styleFrom(
  //                 primary: Colors.blue, // 按钮背景颜色
  //                 onPrimary: Colors.white, // 按钮文字颜色
  //                 minimumSize: Size(double.infinity, 50), // 按钮宽度和高度
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12), // 按钮圆角
  //                 ),
  //               ),
  //               child: const Text(
  //                 '退出登录',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final String name = CommonPreferences.workername.value;
    final int workerid = CommonPreferences.workerid.value;
    final String workertype = CommonPreferences.workertype.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
        backgroundColor: Colors.grey[200],
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
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
                      height: 150.0,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 10.0),
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/worker.png'),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  permission_id == 2
                                      ? Row(
                                    children: [
                                      Text(
                                        '工号: $workerid',
                                        style: const TextStyle(
                                            color: Colors.blue, fontSize: 18),
                                      ),
                                      const SizedBox(width: 20.0),
                                      Text(
                                        '工种: $workertype',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      ),
                                    ],
                                  )
                                      : Container(), // 如果 permission_id 为 1，则显示空白容器
                                ],
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 16),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                  ),
                  permission_id == 2
                      ? Card(
                    margin: const EdgeInsets.all(12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  '今日工时',
                                  style: TextStyle(fontSize: 22),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${todayWorkHours.toStringAsFixed(1)}小时',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 3,
                            color: Colors.grey[400],
                            margin:
                            const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  '本月累计工时',
                                  style: TextStyle(fontSize: 22),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${monthlyWorkHours.toStringAsFixed(1)}小时',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Container(), // 如果 permission_id 为 1，则显示空白容器
                ],
              ),
            ),
            // 将“退出登录”按钮固定在底部
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // 按钮背景颜色
                  onPrimary: Colors.white, // 按钮文字颜色
                  minimumSize: Size(double.infinity, 50), // 按钮宽度和高度
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 按钮圆角
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
    for (var item in items?? []) {
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
    for (var item in items?? []) {
      var workHours = WorkHours.fromJson(item).getWorkHours();
      monthlyHours += workHours;
    }
    return monthlyHours;
  } else {
    debugPrint('获取当月工时失败: ${result?.data}');
    return 0.0;
  }
}

