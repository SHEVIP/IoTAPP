import 'package:flutter/material.dart';
import 'package:untitled/components/board/device_efficiency.dart';
import 'package:untitled/components/board/real_time_monitor.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.center_focus_weak),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('设备看板'),
        actions: const [Icon(Icons.messenger_outline), Icon(Icons.more_vert)],
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: '实时监控',
                  ),
                  Tab(
                    text: '设备效率',
                  ),
                  Tab(
                    text: '效率损失',
                  ),
                ],
              ),
              title: const Text('SMT/全部产线')),
          body: const TabBarView(
            children: [
              RealTimeMonitor(),
              DeviceEfficiency(),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

