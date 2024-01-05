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
      WorkHoursData('张三', 8.5),
      WorkHoursData('李四', 7.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
    ];

    monthRanks = [
      WorkHoursData('王五', 160),
      WorkHoursData('赵六', 150),
    ];

    yearRanks = [
      WorkHoursData('钱七', 1900),
      WorkHoursData('孙八', 1800),
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
