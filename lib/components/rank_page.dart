import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          CurrentDayWorkPage(),
          MonthRankPage(),
          YearRankPage(),
        ],
      ),
    );
  }
}

//三个页面
class CurrentDayWorkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<WorkHoursData> data = [
      WorkHoursData('张三', 8.5),
      WorkHoursData('李四', 7.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
      WorkHoursData('李六', 5.8),
    ];
    final double maxY =
        data.isEmpty ? 10 : data.map((e) => e.hours).reduce(math.max);
    return WorkHoursRankChart(data: data, maxY: maxY);
  }
}

class MonthRankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<WorkHoursData> data = [
      WorkHoursData('王五', 160),
      WorkHoursData('赵六', 150),
    ];
    final double maxY =
        data.isEmpty ? 10 : data.map((e) => e.hours).reduce(math.max);
    return WorkHoursRankChart(data: data, maxY: maxY);
  }
}

class YearRankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<WorkHoursData> data = [
      WorkHoursData('钱七', 1900),
      WorkHoursData('孙八', 1800),
    ];
    final double maxY =
        data.isEmpty ? 10 : data.map((e) => e.hours).reduce(math.max);
    return WorkHoursRankChart(data: data, maxY: maxY);
  }
}

//柱状图渲染
class WorkHoursData {
  final String name;
  final double hours;

  WorkHoursData(this.name, this.hours); // 位置参数的构造函数
}

class WorkHoursRankChart extends StatelessWidget {
  final List<WorkHoursData> data;
  final double maxY;

  WorkHoursRankChart({required this.data, required this.maxY});

  @override
  Widget build(BuildContext context) {
    final int maxBars = 10; // 最多显示10条数据

    // 创建包含10个位置的barGroups
    List<BarChartGroupData> barGroups = List.generate(maxBars, (index) {
      // 如果有实际数据，则显示该数据，否则显示空的柱状图
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: index < data.length ? data[index].hours : 0,
            width: 14,
            colors: [
              index < data.length ? Colors.lightBlueAccent : Colors.transparent
            ],
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 400, // 控制图表高度
        child: RotatedBox(
          quarterTurns: 1, // 旋转90度(顺时针)
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1.15 * maxY,
              barGroups: barGroups.map((barGroup) {
                return BarChartGroupData(
                  x: barGroup.x,
                  barRods: barGroup.barRods.map((barRod) {
                    return BarChartRodData(
                      y: barRod.y,
                      colors: barRod.colors,
                      rodStackItems: barRod.rodStackItems,
                      width: barRod.width,
                      borderRadius: barRod.borderRadius,
                      backDrawRodData: barRod.backDrawRodData,
                      // 去掉 showingTooltipIndicators
                    );
                  }).toList(),
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: SideTitles(showTitles: false),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (context, value) => const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  margin: 16,
                  getTitles: (double value) {
                    return value < data.length ? data[value.toInt()].name : '';
                  },
                  rotateAngle: -90,
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  getTooltipItem: (barChartGroupData, groupIndex,
                      barChartRodData, rodIndex) {
                    final dataIndex = barChartGroupData.x;
                    // 确保 dataIndex 不超出 data 数组的界限
                    if (dataIndex < data.length) {
                      return BarTooltipItem(
                        '${data[dataIndex].hours} 小时',
                        TextStyle(color: Colors.black),
                      );
                    } else {
                      return null; // 如果超出界限，不显示 tooltip
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
