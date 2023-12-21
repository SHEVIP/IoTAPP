// work_hours_details_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class WorkHoursDetailsPage extends StatefulWidget {
  @override
  _WorkHoursDetailsPageState createState() => _WorkHoursDetailsPageState();
}

class _WorkHoursDetailsPageState extends State<WorkHoursDetailsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // 假设这是从后端获取的用户工时数据
  Map<DateTime, double> _userWorkHours = {
    DateTime.utc(2023, 3, 1): 8.5,
    DateTime.utc(2023, 3, 2): 7.0,
    DateTime.utc(2023, 4, 1): 1.5,
    DateTime.utc(2023, 4, 2): 2.0,
    DateTime.utc(2023, 5, 1): 3.5,
    DateTime.utc(2023, 5, 2): 4.0,
    DateTime.utc(2023, 6, 1): 5.5,
    DateTime.utc(2023, 6, 2): 6.0,
    // 添加更多的数据...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('工时详情'),
      ),
      body: Column(
        children: <Widget>[
          // 第一部分: 日期选择器
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('日期'),
                SizedBox(width: 16), // 间隔
                Text('年'),
                SizedBox(width: 16), // 间隔
                // 年份选择器
                DropdownButton<int>(
                  value: _focusedDay.year,
                  items: [for (var year = 2020; year <= DateTime.now().year; year++) year]
                      .map<DropdownMenuItem<int>>((int year) {
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
                SizedBox(width: 16), // 间隔
                Text('月'),
                SizedBox(width: 16), // 间隔
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
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            formatButtonVisible = false,
            locale: 'zh_CN',
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            // Configure calendar appearance and behavior
            // ... (additional configuration)
          ),
          // 第三部分: 显示累计工时
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '累计工时:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '${_calculateTotalWorkHours()}小时',
                  style: TextStyle(fontSize: 16), // 自定义字号
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
        .where((entry) => entry.key.month == _selectedDay.month && entry.key.year == _selectedDay.year)
        .fold(0.0, (sum, entry) => sum + entry.value);
  }
}
