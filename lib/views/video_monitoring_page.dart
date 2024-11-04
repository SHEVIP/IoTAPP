// lib/views/video_monitoring_page.dart

import 'package:flutter/material.dart';

class VideoMonitoringPage extends StatelessWidget {
  const VideoMonitoringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("视频监控"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 上半部分视频窗口
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "视频窗口 1",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // 视频窗口之间的间距

            // 下半部分视频窗口
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "视频窗口 2",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
