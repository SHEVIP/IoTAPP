import 'package:flutter/material.dart';
import 'package:untitled/components/custom_row.dart';
import 'package:untitled/components/custom_table_row.dart';
import 'package:untitled/utils/network_util.dart';

import '../model/task.dart';

class PageViewSwiperText extends StatefulWidget {
  const PageViewSwiperText({super.key});

  @override
  State<PageViewSwiperText> createState() => _PageViewSwiperState();
}

class _PageViewSwiperState extends State<PageViewSwiperText> {
  List<Widget> list = [];
  List<TableRow> child = [];
  List<Task> task_list = [];
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    fetchData();

    // list 应该是itemList!.length个页面，每个页面 1<工单数<=4 显示文字
    list = [];
  }

  fetchData() async {
    List<Widget> updatedList = [];

    var result = await NetworkUtil.getInstance().get("task/tasks?start=1");
    debugPrint('请求消息接口返回数据：${result?.data}');

    if (result?.data['status'] == 200) {
      List<dynamic> itemList = result?.data['data']['item'];
      List<List<String>> blockData = [];

      List<TableRow> updatedChild = [];
      updatedChild.add(
        createCustomTableRow(
            '任务名称', '加工车间', '开始日期', '截止日期', '计划工件数', '已加工工件数', '是否完成', '其他描述',
            fontWeight: FontWeight.bold),
      );

      for (int i = 0; i < itemList.length; i++) {
        Task newTask = Task.fromJson(itemList[i]);
        task_list.add(newTask);

        blockData.add([
          newTask.taskName,
          '任务工件数:${newTask.isFinished}',
          '已加工工件:${newTask.isFinished}'
        ]);
        updatedChild.add(
          createCustomTableRow(
              newTask.taskName,
              newTask.workshopId.toString(),
              newTask.startDate.replaceAll("T", "T\n"),
              newTask.effectiveTime.replaceAll("T", "T\n"),
              ' ',
              ' ',
              newTask.isFinished.toString(),
              newTask.description),
        );
      }
      int chunkSize = 3;
      for (int n = 0; n < blockData.length; n = n + chunkSize) {
        int endindex = n + chunkSize;
        if (endindex > blockData.length) endindex = blockData.length;
        var tempData = blockData.sublist(n, endindex);
        Widget newItem = CustomRow(blockData: tempData);
        updatedList.add(newItem);
      }

      setState(() {
        list = updatedList;
        child = updatedChild;
      });
    } else {
      debugPrint("请求失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('工单列表'),
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
                        _currentIndex = index % list.length;
                      });
                    },
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      if (list.length != 0) return list[index];
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
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: _currentIndex > 0
                            ? () {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        color: Colors.white,
                        onPressed: _currentIndex < list.length - 1
                            ? () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                      ),
                    ],
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '任务清单',
                style: TextStyle(
                  fontSize: 20, // 设置字体大小为18
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 600,
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 500), // 设置最小宽度
                    child: Table(
                        defaultColumnWidth: FixedColumnWidth(100), // 设置列宽
                        border: TableBorder.all(),
                        children: child),
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
