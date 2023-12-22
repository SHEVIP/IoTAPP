import 'package:flutter/material.dart';

class RealTimeMonitor extends StatefulWidget {
  const RealTimeMonitor({super.key});

  @override
  State<RealTimeMonitor> createState() => _RealTimeMonitorState();
}

class _RealTimeMonitorState extends State<RealTimeMonitor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: SizedBox(width: 1000, child: DeviceStats())),
        const Text("2023-12-7 8:55"),
        Expanded(flex: 4, child: DeviceCards())
      ],
    );
  }
}

class DeviceStats extends StatelessWidget {
  final data = <Color>[
    Colors.purple[50]!,
    Colors.purple[100]!,
    Colors.purple[200]!,
    Colors.purple[300]!,
    Colors.purple[400]!,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      scrollDirection: Axis.horizontal,
      children: data
          .map((color) => Container(
        alignment: Alignment.center,
        width: 80,
        height: 10,
        color: color,
        child: Text(
          colorString(color),
          style: const TextStyle(color: Colors.white, shadows: [
            Shadow(
                color: Colors.black,
                offset: Offset(.5, .5),
                blurRadius: 2)
          ]),
        ),
      ))
          .toList(),
    );
  }

  String colorString(Color color) =>
      // "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
  "离线2";
}

class DeviceCards extends StatelessWidget {
  final data = <Color>[
    Colors.purple[50]!,
    Colors.purple[100]!,
    Colors.purple[200]!,
    Colors.purple[300]!,
    Colors.purple[400]!,
    Colors.purple[500]!,
    Colors.purple[600]!,
    Colors.purple[700]!,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 20,
      childAspectRatio: 1 / 1.3,
      children: data.map((color) => _buildItem(color)).toList(),
    );
  }

  Container _buildItem(Color color) => Container(
    alignment: Alignment.center,
    width: 10,
    height: 3000,
    color: color,
    child: const DeviceCard(),
  );
}

class DeviceCard extends StatefulWidget {
  const DeviceCard({super.key});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text("C017"),
        Card(
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: const Text(
              "加工中",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const Text("1.01.03.83")
      ],
    );
  }
}
