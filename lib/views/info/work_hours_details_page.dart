import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/utils/network_util.dart';

import '../../model/work_hours.dart';

class WorkHoursDetailsPage extends StatefulWidget {
  const WorkHoursDetailsPage({super.key});

  @override
  State<WorkHoursDetailsPage> createState() => _WorkHoursDetailsPageState();
}

class _WorkHoursDetailsPageState extends State<WorkHoursDetailsPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, double> _userWorkHours = {};

  @override
  void initState() {
    super.initState();
    fetchWorkHours(5);
  }

  fetchWorkHours(int workerId) async {
    var result = await NetworkUtil.getInstance().get(
        "workerAttendance/workerAttendances?start=1&limit=10&worker_id=$workerId&date=---')");
    debugPrint('接口数据：${result?.data}');
    print("111");

    if (result?.data['status'] == 200) {
      var items = result?.data['data'] as List;
      setState(() {
        _userWorkHours = Map.fromIterable(
          items,
          key: (item) {
            var parsedDate = DateTime.parse(item['date']);
            // 使用UTC时间来确保时区一致性
            return DateTime.utc(
                parsedDate.year, parsedDate.month, parsedDate.day);
          },
          value: (item) => WorkHours.fromJson(item).getWorkHours(),
        );
      });
    } else {
      debugPrint('请求失败: ${result?.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工时详情'),
      ),
      body: Column(
        children: <Widget>[
          // 第一部分: 日期选择器
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('日期'),
                const SizedBox(width: 16),
                const Text('年'),
                const SizedBox(width: 16),
                // 年份选择器
                DropdownButton<int>(
                  value: _focusedDay.year,
                  items: [
                    for (var year = 2020;
                        year <= DateTime.now().year + 5;
                        year++)
                      year
                  ].map<DropdownMenuItem<int>>((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (int? year) {
                    if (year != null) {
                      setState(() {
                        _focusedDay = DateTime(year, _focusedDay.month);
                        _selectedDay = DateTime(year, _selectedDay.month);
                      });
                    }
                  },
                ),
                const SizedBox(width: 16), // 间隔
                const Text('月'),
                const SizedBox(width: 16), // 间隔
                // 月份选择器
                DropdownButton<int>(
                  value: _focusedDay.month,
                  items: [for (var month = 1; month <= 12; month++) month]
                      .map<DropdownMenuItem<int>>((int month) {
                    return DropdownMenuItem<int>(
                      value: month,
                      child: Text(month.toString().padLeft(2, '0')), // 格式化月份
                    );
                  }).toList(),
                  onChanged: (int? month) {
                    if (month != null) {
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, month);
                        _selectedDay = DateTime(_selectedDay.year, month);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // 第二部分: 日历视图
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2222, 12, 30),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${day.day}', // 显示日期
                        style: const TextStyle().copyWith(fontSize: 16.0), // 设置日期字体样式
                      ),
                      if (_userWorkHours.containsKey(day)) // 如果这一天有工作小时数据
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            '${_userWorkHours[day]}小时', // 显示工作小时数
                            style: const TextStyle(
                              fontSize: 12.0, // 工作小时字体大小
                              color: Colors.blue, // 工作小时字体颜色
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            locale: 'zh_CN',
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                // 将_selectedDay更新为新月份的第一天
                _selectedDay = DateTime(focusedDay.year, focusedDay.month, 1);
              });
            },
            // Configure calendar appearance and behavior
            // ... (additional configuration)
          ),
          const SizedBox(height: 16), // 间隔
          // 第三部分: 显示累计工时
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '累计工时:',
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  '${_calculateTotalWorkHours()}小时',
                  style: TextStyle(fontSize: 22), // 自定义字号
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 计算累计工时的函数
  double _calculateTotalWorkHours() {
    // 这里简化处理，实际应用应当考虑更复杂的逻辑
    return _userWorkHours.entries
        .where((entry) =>
            entry.key.month == _selectedDay.month &&
            entry.key.year == _selectedDay.year)
        .fold(0.0, (sum, entry) => sum + entry.value);
  }
}
