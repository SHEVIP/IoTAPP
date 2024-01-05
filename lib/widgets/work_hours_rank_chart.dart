import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled/model/work_hours_data.dart';

class WorkHoursRankChart extends StatelessWidget {
  final List<WorkHoursData> data;

  // 数据的最大值 默认为10
  final double maxY;

  const WorkHoursRankChart({super.key, required this.data, required this.maxY});

  @override
  Widget build(BuildContext context) {
    // 前10人的排名
    const int maxBars = 10;

    // 创建包含10个位置的barGroups
    List<BarChartGroupData> barGroups = List.generate(
        maxBars,
        (index) => BarChartGroupData(
              x: index,
              barsSpace: 100,
              barRods: [
                BarChartRodData(
                  y: index < data.length ? data[index].hours : 0,
                  width: 14,
                  colors: [
                    index < data.length
                        ? Colors.lightBlueAccent
                        : Colors.transparent
                  ],
                  borderRadius: BorderRadius.circular(0),
                )
              ],
            ));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: RotatedBox(
        // 柱状图水平显示
        quarterTurns: 1,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            // 坐标轴的最大值
            maxY: 1.15 * maxY,
            // 不显示边界
            borderData: FlBorderData(show: false),
            // 坐标轴的值
            titlesData: FlTitlesData(
              // 不显示y轴刻度
              leftTitles: SideTitles(showTitles: false),
              // x轴名字为工人姓名
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (context, value) => const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                margin: 16,
                getTitles: (double value) =>
                    value < data.length ? data[value.toInt()].name : '',
                rotateAngle: -90,
              ),
            ),
            // y坐标轴值
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
                  );
                }).toList(),
              );
            }).toList(),
            // 点击后显示数值
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                // 提示框颜色透明
                tooltipBgColor: Colors.transparent,
                // 提示框
                getTooltipItem: (barChartGroupData, groupIndex, barChartRodData,
                        rodIndex) =>
                    BarTooltipItem('${data[barChartGroupData.x].hours} 小时',
                        const TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
