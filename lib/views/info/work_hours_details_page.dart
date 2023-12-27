import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/utils/prefs_util.dart';

import '../../model/work_hours.dart';

class WorkHoursDetailsPage extends StatefulWidget {
  const WorkHoursDetailsPage({super.key});

  @override
  State<WorkHoursDetailsPage> createState() => _WorkHoursDetailsPageState();
}

class _WorkHoursDetailsPageState extends State<WorkHoursDetailsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, double> _userWorkHours = {};

  @override
  void initState() {
    super.initState();
    fetchWorkHours(CommonPreferences.workerid.value);
  }

  fetchWorkHours(int workerId) async {
    var result = await NetworkUtil.getInstance().get(
        "workerAttendance/workerAttendances?start=1&limit=10&worker_id=$workerId&date=---')");
    debugPrint('接口数据：${result?.data}');

    if (result?.data['status'] == 200) {
      var items = result?.data['data']['item'];
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
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
                const Text('年'),
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
                const Text('月'),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2222, 12, 30),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarFormat: CalendarFormat.month,
            locale: 'zh_CN',
            focusedDay: _focusedDay,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${day.day}',
                        style: const TextStyle().copyWith(fontSize: 16.0),
                      ),
                      // 有工作记录则显示数据
                      if (_userWorkHours.containsKey(day))
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            '${_userWorkHours[day]}小时',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = DateTime(focusedDay.year, focusedDay.month, 1);
              });
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  '累计工时:',
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  '${_calculateTotalWorkHours()}小时',
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 累计工时
  double _calculateTotalWorkHours() {
    // 这里简化处理，实际应用应当考虑更复杂的逻辑
    return _userWorkHours.entries
        .where((entry) =>
            entry.key.month == _selectedDay.month &&
            entry.key.year == _selectedDay.year)
        .fold(0.0, (sum, entry) => sum + entry.value);
  }
}
