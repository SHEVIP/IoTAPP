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
        title: Text("生产信息"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 饼图
                        Expanded(
                          child: PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartRadius: MediaQuery.of(context).size.width / 3,
                            colorList: [Colors.blue, Colors.green],
                            chartType: ChartType.disc,
                            legendOptions: LegendOptions(
                              showLegends: true,
                              legendPosition: LegendPosition.bottom,
                              legendShape: BoxShape.circle,
                              legendTextStyle: TextStyle(fontSize: 14),
                              showLegendsInRow: true,
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: true,
                              decimalPlaces: 0,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // 订单信息
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "订单完成进度",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
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
                  );
                } else {
                  return Center(child: Text('未找到订单状态'));
                }
              },
            ),

            Divider(),

            // // 中间部分：刀具扫描标题和二维码扫描功能
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // 左上角的刀具扫描标题
            //       Text(
            //         "刀具扫描",
            //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(height: 10),
            //       // 扫描按钮和结果显示部分
            //       Center(
            //         child: Column(
            //           children: [
            //             // 扫描结果卡片（仅在扫描成功后显示）
            //             if (qrResult != "点击按钮扫描二维码")
            //               _buildScanResultCard(),
            //             // 扫描按钮
            //             ElevatedButton(
            //               onPressed: () async {
            //                 // 跳转到扫描页面并获取结果
            //                 final result = await Navigator.push(
            //                   context,
            //                   MaterialPageRoute(builder: (context) => QRViewExample()),
            //                 );
            //                 if (result != null) {
            //                   setState(() {
            //                     qrResult = result;
            //                   });
            //                 }
            //               },
            //               child: Text("扫描二维码"),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // Divider(),

            // 下半部分：三列表格展示具体工单信息
            Padding(
              padding: const EdgeInsets.all(16.0),
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

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫描二维码'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('扫描结果: ${result!.code}')
                  : Text('正在扫描中...'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // 在返回之前暂停摄像头
      controller.pauseCamera();
      Navigator.pop(context, result?.code); // 返回扫描结果
    });
  }

  @override
  void dispose() {
    // 确保在页面销毁时释放摄像头资源
    controller?.dispose();
    super.dispose();
  }
}