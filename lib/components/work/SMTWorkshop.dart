import 'package:flutter/material.dart';

class SMTWorkshop extends StatefulWidget {
  const SMTWorkshop({super.key});

  @override
  State<SMTWorkshop> createState() => _SMTWorkshopState();
}

class _SMTWorkshopState extends State<SMTWorkshop> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("生产1线"), Text("生产2线"), Text("生产3线"),Icon(Icons.directions_bike)],
            )),
        Expanded(flex: 5, child: DeviceCards())
      ],
    );
  }
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
      childAspectRatio: 1 / 0.5,
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
        Card(
          child: Container(
            width: 100,
            height: 50,
            alignment: Alignment.center,
            child: const Text(
              "CNC001",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
