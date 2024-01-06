import 'package:flutter/material.dart';
import 'package:untitled/views/board/oee_board.dart';
import 'package:untitled/views/board/producing_status_board.dart';
import 'package:untitled/views/board/order_list.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: '生产状态',
                ),
                Tab(
                  text: '工单列表',
                ),
                Tab(
                  text: '设备效率',
                ),
              ],
            )),
        body: const TabBarView(
          children: [
            ProducingStatusBoard(),
            OrderList(),
            OEEBoard(),
          ],
        ),
      ),
    );
  }
}
