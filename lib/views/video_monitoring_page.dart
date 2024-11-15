import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoMonitoringPage extends StatefulWidget {
  const VideoMonitoringPage({Key? key}) : super(key: key);

  @override
  State<VideoMonitoringPage> createState() => _VideoMonitoringPageState();
}

class _VideoMonitoringPageState extends State<VideoMonitoringPage> {
  late VlcPlayerController _vlcPlayerController;

  @override
  void initState() {
    super.initState();
    try {
      _vlcPlayerController = VlcPlayerController.network(
        'http://lc-test.vip.cpolar.cn/video/stream.m3u8',
        hwAcc: HwAcc.full,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
    } catch (e) {
      print("Error initializing VlcPlayerController: $e");
    }

  }

  @override
  void dispose() {
    _vlcPlayerController.stop(); // 停止视频流播放
    _vlcPlayerController.dispose(); // 释放VLC资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width - 32;
    final double containerHeight = containerWidth * 3 / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text("视频监控", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: VlcPlayer(
                  controller: _vlcPlayerController,
                  aspectRatio: containerWidth / containerHeight,
                  placeholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 下半部分的视频窗口（目前保持空白或可以替换成其他内容）
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "视频窗口 2",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
