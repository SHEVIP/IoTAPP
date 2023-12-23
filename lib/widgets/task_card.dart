import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final List<List<String>> blockData;

  const TaskCard({super.key, required this.blockData});

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = blockData.map((data) {
      String blockName = data[0];
      String line1 = data[1];
      String line2 = data[2];

      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                blockName,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                line1,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                line2,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Row(
      children: rowChildren,
    );
  }
}
