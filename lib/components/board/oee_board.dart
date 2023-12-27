import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/vo/oee_vo.dart';
import 'package:untitled/widgets/legend_widget.dart';

class OEEBoard extends StatefulWidget {
  const OEEBoard({super.key});

  @override
  State<OEEBoard> createState() => _OEEBoardState();
}

class _OEEBoardState extends State<OEEBoard> {
  List<OEEVO> oeeVOs = [];
  List<BarChartGroupData> barGroups = [];

  @override
  void initState() {
    getOee();
    super.initState();
  }

  getOee() async {
    Map<String, dynamic> params = {};
    params['workshop_id'] = 1;
    var result =
        await NetworkUtil.getInstance().post('screen/oee', params: params);
    // debugPrint('请求数据${result?.data}');

    if (result?.data['status'] == 200) {
      var oeeRankList = result?.data['data']['OEERank'] as List;
      oeeVOs = oeeRankList.map((item) => OEEVO.fromJson(item)).toList();
      // debugPrint('数据结果${oeeVOs[0].run}');
      // debugPrint('数据结果${oeeVOs[1].run}');
      // debugPrint('数据结果${oeeVOs[2].run}');
      setState(() {});
    }

    barGroups = List.generate(
        maxBars,
        (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: 1,
                  rodStackItems: [
                    BarChartRodStackItem(0, oeeVOs[index].run, Colors.red),
                    BarChartRodStackItem(
                        oeeVOs[index].run,
                        oeeVOs[index].run + oeeVOs[index].waiting,
                        Colors.green),
                    BarChartRodStackItem(
                        oeeVOs[index].run + oeeVOs[index].waiting,
                        oeeVOs[index].run +
                            oeeVOs[index].waiting +
                            oeeVOs[index].closed,
                        Colors.blue),
                    BarChartRodStackItem(
                        oeeVOs[index].run +
                            oeeVOs[index].waiting +
                            oeeVOs[index].closed,1,
                        Colors.yellow),
                  ],
                  width: 14,
                ),
              ],
            ));
    setState(() {});
  }

  // 前10人的排名
  static const int maxBars = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LegendsListWidget(
          legends: [
            Legend('运行', Colors.red),
            Legend('等待', Colors.green),
            Legend('停机', Colors.blue),
            Legend('异常', Colors.yellow),
          ],
        ),
        Expanded(
            child: RotatedBox(
          // 柱状图水平显示
          quarterTurns: 1,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  margin: 16,
                  getTitles: (double value) => value < oeeVOs.length
                      ? '${oeeVOs[value.toInt()].machineID}'
                      : '',
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
            ),
          ),
        ))
      ],
    );
  }
}
