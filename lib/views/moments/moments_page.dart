import 'package:flutter/material.dart';
import 'package:untitled/model/work_hours_data.dart';
import 'dart:math' as math;
import 'package:untitled/widgets/work_hours_rank_chart.dart';


class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<WorkHoursData> dayRanks = [];
  List<WorkHoursData> monthRanks = [];
  List<WorkHoursData> yearRanks = [];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    dayRanks = [
      WorkHoursData('孙建国', 8.5),
      WorkHoursData('朴维', 7.8),
      WorkHoursData('赵小泽', 6.8),
      WorkHoursData('张伟', 6.5),
      WorkHoursData('王小帆', 6.2),
      WorkHoursData('郑小红', 6.2),
      WorkHoursData('陈静', 6.0),
      WorkHoursData('徐志强', 5.8),
      WorkHoursData('杨涛', 5.4),
      WorkHoursData('Alan', 5.3),
    ];

    monthRanks = [
      WorkHoursData('赵小泽', 255),
      WorkHoursData('张伟', 254),
      WorkHoursData('王小帆', 251),
      WorkHoursData('郑小红', 240),
      WorkHoursData('孙建国', 239),
      WorkHoursData('朴维', 220),
      WorkHoursData('陈静', 219),
      WorkHoursData('徐志强', 210),
      WorkHoursData('杨涛', 201),
      WorkHoursData('Alan', 200),
    ];

    yearRanks = [
      WorkHoursData('陈静', 2200),
      WorkHoursData('徐志强', 2178),
      WorkHoursData('杨涛', 2133),
      WorkHoursData('Alan', 2103),
      WorkHoursData('孙建国', 2101),
      WorkHoursData('朴维', 2099),
      WorkHoursData('赵小泽', 2012),
      WorkHoursData('张伟', 2000),
      WorkHoursData('王小帆', 1999),
      WorkHoursData('郑小红', 1986),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工时统计'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '今日工时排名'),
            Tab(text: '月度工时排名'),
            Tab(text: '年度工时排名'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          WorkHoursRankChart(data: dayRanks, maxY: getChartMax(dayRanks)),
          WorkHoursRankChart(data: monthRanks, maxY: getChartMax(monthRanks)),
          WorkHoursRankChart(data: yearRanks, maxY: getChartMax(yearRanks)),
        ],
      ),
    );
  }

  double getChartMax(List<WorkHoursData> data) => data.isEmpty ? 10 : data.map((e) => e.hours).reduce(math.max);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
