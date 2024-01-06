import 'package:flutter/material.dart';
import 'package:untitled/views/worktop/device_management_page.dart';
import 'package:untitled/views/worktop/inventory_page.dart';
import 'package:untitled/views/worktop/security_management.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(tabs: [
              Tab(text: "设备管理"),
              Tab(text: "安全管理"),
              Tab(text: "库存管理"),
            ]),
          ),
          body: TabBarView(
            children: [
              DeviceManagementPage(),
              SecurityManagementPage(),
              InventoryPage(),
            ],
          ),
        ),
      ),
    );
  }
}