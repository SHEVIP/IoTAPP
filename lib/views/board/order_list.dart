import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/model/order.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<Order>> futureOrders;
  late Future<Map<String, dynamic>> orderStatus;
  String qrResult = "点击按钮扫描二维码";

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
    orderStatus = fetchOrderStatus();
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

  Future<Map<String, dynamic>> fetchOrderStatus() async {
    Map<String, dynamic> params = {
      "workshop_id": 1,
    };
    var response = await NetworkUtil.getInstance().post("screen/getOrderStatus", params: params);

    if (response != null && response.data['status'] == 200) {
      Map<String, dynamic> data = response.data['data'];
      return data;
    } else {
      throw Exception('Failed to load order status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("生产信息", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 上半部分：饼图和订单信息
              FutureBuilder<Map<String, dynamic>>(
                future: orderStatus,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('错误: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    Map<String, dynamic> data = snapshot.data!;
                    int doneNum = data['done_num'];
                    int quantityNumber = data['quantity_number'];
                    int remainingNum = quantityNumber - doneNum;
                    String orderNumber = data['order_number'];
                    int timePerItem = 5; // 假设每个工件加工时间在 `time_used`

                    Map<String, double> dataMap = {
                      "已完成": doneNum.toDouble(),
                      "未完成": remainingNum.toDouble(),
                    };

                    int estimatedTime = remainingNum * timePerItem; // 计算预计时间

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 饼图和简化图例
                            Expanded(
                              child: Column(
                                children: [
                                  PieChart(
                                    dataMap: dataMap,
                                    animationDuration: Duration(milliseconds: 800),
                                    chartRadius: MediaQuery.of(context).size.width / 4,
                                    colorList: [Colors.blue, Colors.green],
                                    chartType: ChartType.disc,
                                    legendOptions: const LegendOptions(
                                      showLegends: true,
                                      legendPosition: LegendPosition.top,
                                      legendShape: BoxShape.circle,
                                      legendTextStyle: TextStyle(fontSize: 12),
                                      showLegendsInRow: true,
                                      legendLabels: {
                                        "已完成": "已完成",
                                        "未完成": "未完成",
                                      },
                                      // legendSpacing: 4, // 缩小图例之间的间距
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: false,
                                      decimalPlaces: 0,
                                      chartValueBackgroundColor: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            // 订单信息
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "订单完成进度",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "订单单号：$orderNumber",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "工件进度：$doneNum/$quantityNumber",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "预计时间：$estimatedTime 分钟",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('未找到订单状态'));
                  }
                },
              ),

              Divider(height: 32),

              // 下半部分：三列表格展示具体工单信息
              Padding(
                padding: const EdgeInsets.all(0.0),
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
                          return Column(
                            children: orders.map((order) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: ListTile(
                                    title: Text(
                                      "型号: ${order.order_type}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text("数量: ${order.item_number}"),
                                        SizedBox(height: 5),
                                        Text("工序: ${order.procedure_name}"),
                                      ],
                                    ),
                                    leading: Icon(
                                      Icons.assignment,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
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
      ),
    );
  }

  // 创建扫描结果的友好UI展示
  Widget _buildScanResultCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.teal[100],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.qr_code_scanner, size: 60, color: Colors.teal),
            SizedBox(height: 15),
            Text(
              "扫描结果",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              qrResult,
              style: TextStyle(fontSize: 18, color: Colors.teal[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 显示扫描成功的弹窗
  void _showScanSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('扫描成功！'),
          actions: <Widget>[
            TextButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
            ),
          ],
        );
      },
    );
  }
}
