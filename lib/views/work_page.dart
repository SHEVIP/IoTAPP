import 'package:flutter/material.dart';
import 'package:untitled/components/work/SMTWorkshop.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.center_focus_weak),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('工位操作'),
        actions: const [Icon(Icons.messenger_outline), Icon(Icons.more_vert)],
      ),
      body: const DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(tabs: <Widget>[
              Tab(text: "SMT车间"),
              Tab(text: "组装车间"),
              Tab(text: "包装车间"),
            ]),
          ),
          body: TabBarView(
            children: [
              SMTWorkshop(),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ExceptionReportPage()));
          },
          child: const Icon(Icons.add)),
    );
  }
}

class ExceptionReportPage extends StatefulWidget {
  const ExceptionReportPage({super.key});

  @override
  State<ExceptionReportPage> createState() => _ExceptionReportPageState();
}

class _ExceptionReportPageState extends State<ExceptionReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("异常上报"),
      ),
      body: DataTable(
        columns: [
          DataColumn(label: Text('异常')),
          DataColumn(label: Text('时间')),
          DataColumn(label: Text('原因')),
          DataColumn(label: Text('')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('等待')),
            DataCell(Text('4/26 12:01 -')),
            DataCell(Text('休息')),
            DataCell(Icon(Icons.arrow_forward)),
          ]),
          DataRow(cells: [
            DataCell(Text('等待')),
            DataCell(Text('4/26 12:01 -')),
            DataCell(Text('休息')),
            DataCell(Icon(Icons.arrow_forward)),
          ]),
          DataRow(cells: [
            DataCell(Text('等待')),
            DataCell(Text('4/26 12:01 -')),
            DataCell(Text('休息')),
            DataCell(Icon(Icons.arrow_forward)),
          ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonExceptionPage()));
          },
          child: Icon(Icons.add)),
    );
  }
}

class PersonExceptionPage extends StatefulWidget {
  const PersonExceptionPage({super.key});

  @override
  State<PersonExceptionPage> createState() => _PersonExceptionPageState();
}

class _PersonExceptionPageState extends State<PersonExceptionPage> {
  _alertDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('选择异常原因'),
            content: Column(
              children: [
                Text("缺料"),
                Text("物料品质异常"),
                Text("制程异常"),
                Text("规格变更")
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "取消");
                  }),
              TextButton(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context, "确定");
                },
              ),
            ],
          );
        });

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("莫春组"),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text("4/26 常白班 8:00 - 20:00"),
            Text("未完成"),
            Text("已完成")
          ]),
          TextField(
            decoration: InputDecoration(
              hintText: '请输入搜索内容',
              icon: Icon(Icons.search),
            ),
            onChanged: (text) {
              // 处理搜索内容变化
            },
          ),
          Expanded(child: ExceptionItem())
        ],
      ),
      // floatingActionButton:FloatingActionButton(
      //     onPressed: () {
      //       _alertDialog();
      //     },
      //     child: Icon(Icons.add)),
    );
  }
}

class ExceptionItem extends StatelessWidget {
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
      children: data
          .map((color) => Container(
                alignment: Alignment.center,
                width: 80,
                height: 100,
                // color: color,
                // child: Text("hello"),
              ))
          .toList(),
    );
  }
}
