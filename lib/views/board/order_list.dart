import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/model/order.dart';
import 'package:untitled/model/procedure.dart';
import 'package:untitled/utils/prefs_util.dart';
import 'package:untitled/widgets/task_card.dart';
import 'package:untitled/widgets/task_table_row.dart';
import 'package:untitled/utils/network_util.dart';

import '../../model/task.dart';




class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    Map<String, dynamic> params = {
      "workshop_id": 1,
      "start": 1,
      "limit": 100,
    };
    var response = await NetworkUtil.getInstance().post("screen/order",params: params);

  if (response != null && response.data['status'] == 200) {
    // 你需要检查 'Orders' 是否是response.data['data']['item']中的一个键
    List<dynamic> ordersJson = response.data['data']['item']['Orders'];
    
    // 使用.map()函数将每个json对象转换为Order对象
    List<Order> orders = ordersJson.map<Order>((json) => Order.fromJson(json)).toList();
    
    return orders; // 这里返回的是List<Order>，不需要额外包装为Future，因为这个函数已经是异步函数了。
  } else {
    throw Exception('Failed to load orders');
  }
  }

 
  Widget _buildRow(Order order) {
    return ExpansionTile(
      title: Text(order.taskName),
      subtitle: Text('${order.totalNum}计划工件数, ${order.finishNum}已加工'),
      trailing: Text(order.isFinished == 1 ? '已完成' : '进行中'),
      children: <Widget>[
        ListTile(
          title: Text('详细信息'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('加工车间: ${order.workshopName}'),
              Text('开始日期: ${order.startTime}'),
              Text('截止日期: ${order.effectiveTime}'),
              Text('描述: ${order.description}'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Order> orders = snapshot.data!;
          return ListView(
            children: orders.map(_buildRow).toList(),
          );
        } else {
          return Center(child: Text('No orders found'));
        }
      },
    );
  }
}