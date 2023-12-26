import 'package:flutter/material.dart';
import 'package:untitled/components/work/device_card.dart';

class DeviceManagementPage extends StatelessWidget {
  const DeviceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DeviceCard(
              deviceName: '设备1', onTap: () => reportException(context, '设备1')),
          DeviceCard(
              deviceName: '设备2', onTap: () => reportException(context, '设备2')),
          DeviceCard(
              deviceName: '设备3', onTap: () => reportException(context, '设备3')),
          DeviceCard(
              deviceName: '设备4', onTap: () => reportException(context, '设备4')),
          DeviceCard(
              deviceName: '设备5', onTap: () => reportException(context, '设备5')),
        ],
      ),
    );
  }

  void reportException(BuildContext context, String deviceName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '异常上报 - $deviceName',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Text('选择异常原因：'),
                const SizedBox(height: 8.0),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 在这里添加上报异常的逻辑，可以发送 POST 请求
                        // 暂时未提供具体的 URL 地址
                        Navigator.pop(context);
                      },
                      child: const Text('物料品质异常'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 在这里添加上报异常的逻辑，可以发送 POST 请求
                        // 暂时未提供具体的 URL 地址
                        Navigator.pop(context);
                      },
                      child: const Text('缺料'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 在这里添加上报异常的逻辑，可以发送 POST 请求
                        // 暂时未提供具体的 URL 地址
                        Navigator.pop(context);
                      },
                      child: const Text('制程异常'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 在这里添加上报异常的逻辑，可以发送 POST 请求
                        // 暂时未提供具体的 URL 地址
                        Navigator.pop(context);
                      },
                      child: const Text('规格变更'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

