import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/model/order.dart';

import '../utils/prefs_util.dart';

class FactoryManagementPage extends StatefulWidget {
  const FactoryManagementPage({super.key});

  @override
  State<FactoryManagementPage> createState() => _FactoryManagementPageState();
}

class _FactoryManagementPageState extends State<FactoryManagementPage> {
  List<double> operatingRateData = [];
  List<String> operatingRateMonths = [];
  List<double> deliveryRateData = [];
  List<String> deliveryRateMonths = [];
  List<double> qualityRateData = [];
  List<String> qualityRateOrderNumbers = [];

  static const platform = MethodChannel('com.example.untitled/open_browser');
  final String largeScreenUrl = "http://lc-panel.vip.cpolar.cn/#/";
  // final String largeScreenUrl = "http://lc-cdn.vip.cpolar.cn/api/v1/user/login?username=$CommonPreferences.username.value&password=$CommonPreferences.password.value";
  late Future<List<Order>> futureOrders;

  Future<void> _openLargeScreenUrl() async {
    try {
      await platform.invokeMethod('openBrowser', {"url": largeScreenUrl});
    } on PlatformException catch (e) {
      print("Failed to open URL: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    futureOrders = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    Map<String, dynamic> params = {
      "start": 1,
      "limit": 100,
    };
    var response = await NetworkUtil.getInstance().post("screen/order", params: params);

    if (response != null && response.data['status'] == 200) {
      List<dynamic> ordersJson = response.data['data']['item']['Orders'];
      List<Order> orders = ordersJson.map<Order>((json) => Order.fromJson(json)).toList();
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> fetchData() async {
    try {
      // Fetch operating rate data
      var result = await NetworkUtil.getInstance().post("screen/combinedrate");
      if (result?.data['status'] == 200) {
        final monthlyRates = result?.data['data']['monthly_rates'];
        if (monthlyRates != null && monthlyRates.isNotEmpty) {
          final firstDeviceData = monthlyRates.values.first;
          setState(() {
            operatingRateData = [];
            operatingRateMonths = [];
            firstDeviceData.forEach((key, value) {
              final rate = value['u_rate'];
              if (rate != null && rate is num) {
                operatingRateData.add(rate.toDouble());
                operatingRateMonths.add(key.substring(5)); // 获取月份部分
              }
            });
          });
        }
      }

      // Fetch delivery rate data
      var deliveryResult = await NetworkUtil.getInstance().get("workOrder/rate");
      if (deliveryResult?.data['status'] == 200) {
        final deliveryRates = deliveryResult?.data['data']['delivery_rate'];
        if (deliveryRates != null && deliveryRates.isNotEmpty) {
          setState(() {
            deliveryRateData = [];
            deliveryRateMonths = [];
            deliveryRates.forEach((key, value) {
              if (value != null && value is num) {
                deliveryRateData.add(value.toDouble());
                deliveryRateMonths.add(key.split('-')[1]); // 获取月份部分
              }
            });
          });
        }
      }

      // Fetch quality rate data
      var qualityResult = await NetworkUtil.getInstance().post("screen/qualityRate");
      if (qualityResult?.data['status'] == 200) {
        final workOrders = qualityResult?.data['data']['work_orders'];
        if (workOrders != null && workOrders.isNotEmpty) {
          debugPrint(workOrders.toString());
          setState(() {
            qualityRateData = [];
            qualityRateOrderNumbers = [];
            workOrders.forEach((order) {
              final rate = order['FinalQualityRate'];
              final orderNumber = order['OrderNumber'];
              if (rate != null && rate is num) {
                qualityRateData.add(rate.toDouble());
                qualityRateOrderNumbers.add(orderNumber); // 获取订单号
              }
            });
          });
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('工厂信息'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: _openLargeScreenUrl,
              child: Row(
                children: [
                  const Icon(Icons.fullscreen, color: Colors.blue),
                  const SizedBox(width: 5),
                  const Text(
                    "大屏展示",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RateChart(
              title: '稼动率',
              data: operatingRateData,
              xAxisLabels: operatingRateMonths,
              xAxisLabel: '',
              yAxisLabel: '',
            ),
            const SizedBox(height: 10),
            RateChart(
              title: '交期率',
              data: deliveryRateData,
              xAxisLabels: deliveryRateMonths,
              xAxisLabel: '',
              yAxisLabel: '',
            ),
            const SizedBox(height: 10),
            QualityBarChart(
              title: '优品率',
              data: qualityRateData,
              labels: qualityRateOrderNumbers,
              // yAxisLabel: '优品率(%)',
            ),
            const SizedBox(height: 10),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "工单详情",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<Order>>(
                    future: futureOrders,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('错误: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        List<Order> orders = snapshot.data!;

                        return Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[300]),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "型号",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "数量",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "工序",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            // 动态生成数据行
                            for (var order in orders)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(order.order_type), // 型号
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(order.item_number.toString()), // 数量
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(order.procedure_name), // 工序
                                  ),
                                ],
                              ),
                          ],
                        );
                      } else {
                        return Center(child: Text('未找到工单信息'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RateChart extends StatelessWidget {
  final String title;
  final List<double> data;
  final List<String> xAxisLabels;
  final String xAxisLabel;
  final String yAxisLabel;

  const RateChart({
    required this.title,
    required this.data,
    required this.xAxisLabels,
    required this.xAxisLabel,
    required this.yAxisLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (data.isEmpty)
            Center(child: Text("No data available for $title"))
          else
            CustomPaint(
              painter: LineChartPainter(data, xAxisLabels, xAxisLabel, yAxisLabel),
              child: Container(),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class QualityBarChart extends StatelessWidget {
  final String title;
  final List<double> data;
  final List<String> labels;

  const QualityBarChart({
    required this.title,
    required this.data,
    required this.labels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity, // 使得宽度与父组件一致
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (data.isEmpty)
            Center(child: Text("No data available for $title"))
          else
            CustomPaint(
              painter: _BarPainter(data, labels),
              child: Container(),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double padding = 40.0;

  _BarPainter(this.data, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()..color = Colors.blue;
    final axisPaint = Paint()..color = Colors.grey..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Draw Y-axis (0-100%)
    const minY = 0.0;
    const maxY = 100.0;
    final yRange = maxY - minY;
    final yAxisStep = (size.height - 2 * padding) / yRange;

    // Draw the Y-axis and labels
    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      axisPaint,
    );

    for (int i = 0; i <= 5; i++) {
      final y = size.height - padding - (i * yAxisStep * 20); // 20% increments on Y-axis
      textPainter.text = TextSpan(
        text: '${i * 20}%',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(padding - textPainter.width - 5, y - textPainter.height / 2),
      );

      // Draw horizontal lines for each Y-axis label
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        axisPaint..color = Colors.grey.withOpacity(0.3),
      );
    }

    // Draw X-axis labels and bars
    final barWidth = (size.width - 2 * padding) / (data.length * 2);
    for (int i = 0; i < data.length; i++) {
      final x = padding + i * 2 * barWidth + barWidth / 2;
      final barHeight = (data[i] / maxY) * (size.height - 2 * padding);
      final y = size.height - padding - barHeight;

      // Draw the bar
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), paint);

      // Draw percentage above each bar
      textPainter.text = TextSpan(
        text: '${data[i].toInt()}%',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, y - 16),
      );

      // Draw order number label below each bar
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + (barWidth - textPainter.width) / 2, size.height - padding + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class BarChartPainter extends StatelessWidget {
  final List<double> data;
  final List<String> xAxisLabels;
  final String yAxisLabel;

  const BarChartPainter(this.data, this.xAxisLabels, this.yAxisLabel);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarPainter(data, xAxisLabels),
    );
  }
}


class LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> xAxisLabels;
  final String xAxisLabel;
  final String yAxisLabel;
  final double padding = 30.0;

  LineChartPainter(this.data, this.xAxisLabels, this.xAxisLabel, this.yAxisLabel);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 0.5;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Draw X and Y axes
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      axisPaint,
    );
    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      axisPaint,
    );

    // Fixed Y-axis range from 0 to 100
    const minY = 0.0;
    const maxY = 100.0;
    final yRange = maxY - minY;

    // Draw horizontal grid lines every 20% with labels on the y-axis
    for (int i = 0; i <= 5; i++) {
      final y = size.height - padding - (i * (size.height - 2 * padding) / 5);
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );

      // Draw y-axis labels
      textPainter.text = TextSpan(
        text: '${(i * 20).toStringAsFixed(0)}%',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(padding - textPainter.width - 4, y - textPainter.height / 2),
      );
    }

    // Draw line chart
    final xStep = (size.width - 2 * padding) / (data.length - 1);
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = padding + i * xStep;
      final y = size.height - padding - ((data[i] - minY) / yRange * (size.height - 2 * padding));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Draw X-axis label
    textPainter.text = TextSpan(
      text: xAxisLabel,
      style: TextStyle(color: Colors.black, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, size.height - padding / 2),
    );

    // Draw X-axis labels
    for (int i = 0; i < xAxisLabels.length; i++) {
      final x = padding + i * xStep;
      textPainter.text = TextSpan(
        text: xAxisLabels[i],
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - padding / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

