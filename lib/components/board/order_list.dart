import 'package:flutter/material.dart';
import 'package:untitled/widgets/task_card.dart';
import 'package:untitled/widgets/task_table_row.dart';
import 'package:untitled/utils/network_util.dart';

import '../../model/task.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<TaskCard> cards = [];
  List<TableRow> tableRows = [];

  // TODO: 这里的逻辑有点绕 因为每页展示3个Card 有多页。
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    tableRows.add(createCustomTable4Row(
        '任务名称', '加工车间', '开始日期', '截止日期',
        fontWeight: FontWeight.bold));
    // tableRows.add(createCustomTableRow(
    //     '任务名称', '加工车间', '开始日期', '截止日期', '计划工件数', '已加工工件数', '是否完成', '其他描述',
    //     fontWeight: FontWeight.bold));
    getTasks();
  }

  getTasks() async {
    // 请求接口
    var result = await NetworkUtil.getInstance().get("task/tasks?start=1");
    // debugPrint('请求消息接口返回数据：${result?.data}');

    if (result?.data['status'] == 200) {
      List<dynamic> itemList = result?.data['data']['item'];
      List<List<String>> blockData = [];

      // 表格
      for (int i = 0; i < itemList.length; i++) {
        Task newTask = Task.fromJson(itemList[i]);

        blockData.add([
          newTask.taskName,
          '任务工件数:${newTask.isFinished}',
          '已加工工件:${newTask.isFinished}'
        ]);
        tableRows.add(
          createCustomTable4Row(
              newTask.taskName,
              newTask.workshopId.toString(),
              newTask.startDate.replaceAll("T", "T\n"),
              newTask.effectiveTime.replaceAll("T", "T\n"),
              // ' ',
              // ' ',
              // newTask.isFinished.toString(),
              // newTask.description),
          ),
        );
      }

      // 卡片列表
      int chunkSize = 3;
      for (int n = 0; n < blockData.length; n = n + chunkSize) {
        int endIndex = n + chunkSize;
        if (endIndex > blockData.length) endIndex = blockData.length;
        var tempData = blockData.sublist(n, endIndex);
        TaskCard newItem = TaskCard(blockData: tempData);
        cards.add(newItem);
      }

      setState(() {});
    } else {
      debugPrint("请求失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index % cards.length;
                      });
                    },
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      if (cards.isNotEmpty) return cards[index];
                      return null;
                      // index的值是0-1000
                      // 0  1  2    0  1  2   0  1 2
                    }),
              ),
              Positioned(
                  left: 0,
                  right: 0, //设置 left:0 right:0就会站满整行
                  bottom: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: _currentIndex > 0
                            ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.white,
                        onPressed: _currentIndex < cards.length - 1
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                      ),
                    ],
                  )),
            ],
          ),
          const Center(child: Text('任务清单', style: TextStyle(fontSize: 20))),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 600,
              color: Colors.white,
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 500), // 设置最小宽度
                    child: Table(
                        defaultColumnWidth: const FixedColumnWidth(100), // 设置列宽
                        border: TableBorder.all(),
                        children: tableRows),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
