import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/model/message.dart';
import 'package:untitled/utils/network_util.dart';

class MessageScroll extends StatefulWidget {
  const MessageScroll({super.key});

  @override
  State<MessageScroll> createState() => _MessageScrollState();
}

class _MessageScrollState extends State<MessageScroll> {
  List<Message> messages = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  fetchMessages() async {
    var result = await NetworkUtil.getInstance()
        .get("message/messages?start=1&limit=10");
    debugPrint('请求消息接口返回数据：${result?.data}');

    if (result?.data['status'] == 200) {
      var items = result?.data['data']['item'] as List;
      setState(() {
        messages = items.map((item) => Message.fromJson(item)).toList();
      });
    } else {
      debugPrint('请求失败: $result');
    }
  }

  readMessage(int messageId, int messageIndex) async {
    Map<String, dynamic> body = {};
    body['is_read'] = 1;
    var result =
        await NetworkUtil.getInstance().put("message/$messageId", params: body);
    if (result?.data['status'] == 200) {
      messages[messageIndex].isRead = true;
      debugPrint('更新messageId：$messageId ,成功');
    } else {
      debugPrint('异常错误');
    }
  }

  showDetailDialog(Message message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('消息详情'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Machine ID: ${message.machineId}'),
                Text('Sent Date: ${message.sentDate}'),
                Text('Content: ${message.content}'),
                Text('Type: ${message.type}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            height: 60.0,
            padding: const EdgeInsets.fromLTRB(25.0, 5.0, 10.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('我的消息', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon:
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: isExpanded ? messages.length : 0,
            itemBuilder: (context, index) {
              Message message = messages[index];
              return ListTile(
                title: Text('${message.machineId} 号机器 ${message.title}，请您及时查看'),
                trailing: message.isRead
                    ? null
                    : const Icon(Icons.brightness_1,
                        color: Colors.red, size: 10.0),
                onTap: () {
                  showDetailDialog(message);
                  if (!message.isRead) {
                    readMessage(message.messageId, index);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
