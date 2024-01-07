import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:untitled/utils/network_util.dart';


class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late Future<List<InventoryItem>> inventoryItems;

  @override
  void initState() {
    super.initState();
    inventoryItems = fetchInventoryItems();
  }
  
  Future<List<InventoryItem>> fetchInventoryItems() async {
    // 使用 NetworkUtil 进行 GET 请求
    var response = await NetworkUtil.getInstance().get("inventory/inventorys?start=1&limit=1000");

    // 检查响应是否不为 null 且状态码为 200
    if (response?.data['status'] == 200) {
      // 解析返回的数据
      List<dynamic> data = response?.data['data']['item'] ?? [];
      return data.map((item) => InventoryItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load inventory');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('零件库存管理'),
      ),
      body: FutureBuilder<List<InventoryItem>>(
        future: inventoryItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InventoryList(items: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class InventoryItem {
  final int id;
  final String itemType;
  final int inventoryType;
  final int inventoryNum;
  final String date;
  final String description;
  final String field1;

  InventoryItem({required this.id, required this.itemType, required this.inventoryType, required this.inventoryNum, required this.date, required this.description, required this.field1});

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      itemType: json['item_type'],
      inventoryType: json['iventory_type'],
      inventoryNum: json['iventory_num'],
      date: json['date'],
      description: json['description'],
      field1: json['field1'],
    );
  }
}

class InventoryList extends StatelessWidget {
  final List<InventoryItem> items;

  InventoryList({required this.items});

  @override
  Widget build(BuildContext context) {
    // 将项目根据 field1 分组
    var groupedItems = groupByField1(items);

    return ListView.builder(
      itemCount: groupedItems.length,
      itemBuilder: (context, index) {
        String field1 = groupedItems.keys.elementAt(index);
        return InventoryGroup(field1: field1, items: groupedItems[field1]!);
      },
    );
  }

  // 分组函数
  Map<String, List<InventoryItem>> groupByField1(List<InventoryItem> items) {
    Map<String, List<InventoryItem>> groupedMap = {};
    for (var item in items) {
      if (!groupedMap.containsKey(item.field1)) {
        groupedMap[item.field1] = [];
      }
      groupedMap[item.field1]!.add(item);
    }
    return groupedMap;
  }
}

class InventoryGroup extends StatelessWidget {
  final String field1;
  final List<InventoryItem> items;

  InventoryGroup({required this.field1, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[200],
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // 添加圆角
      ),
      child: ExpansionTile(
        title: Text(
          field1,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: items.map((item) => InventoryCard(item: item)).toList(),
        initiallyExpanded: false, // 初始状态是否展开
      ),
    );
  }
}



class InventoryCard extends StatelessWidget {
  final InventoryItem item;

  InventoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.inventory), // 示例中使用图标，您可以替换为图片
        title: Text(item.itemType),
        subtitle: Text('库存数量: ${item.inventoryNum}'),
        onTap: () => showInventoryDialog(context, item.id, item.itemType, item.inventoryNum),
      ),
    );
  }

  void showInventoryDialog(BuildContext context, int id, String itemType, int currentInventory) {
    TextEditingController _controller = TextEditingController(text: currentInventory.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("调整 （$itemType） 的库存"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () { _updateInventory(_controller, 1); },
                      child: Text("+1", style: TextStyle(color: Colors.green,fontSize: 28)),
                    ),
                    SizedBox(width: 58),  // 添加间隔
                    TextButton(
                      onPressed: () { _updateInventory(_controller, 10); },
                      child: Text("+10", style: TextStyle(color: Colors.green,fontSize: 28)),
                    ),
                  ],
                ),
                SizedBox(height: 8), // 添加垂直间隔
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue,
                  ),
                  decoration: InputDecoration(
                    hintText: '输入库存数量',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(20),  // 更圆的边角
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),  // 增加垂直填充，减少水平填充
                  ),
                ),


                SizedBox(height: 8), // 添加垂直间隔
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () { _updateInventory(_controller, -1); },
                      child: Text("-1", style: TextStyle(color: Colors.red,fontSize: 28)),
                    ),
                    SizedBox(width: 58),  // 添加间隔
                    TextButton(
                      onPressed: () { _updateInventory(_controller, -10); },
                      child: Text("-10", style: TextStyle(color: Colors.red,fontSize: 28)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('提交修改'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitInventoryChange(context, id, itemType, currentInventory, int.parse(_controller.text));
              },
            ),
          ],
        );
      },
    );
  }


  void _updateInventory(TextEditingController controller, int change) {
    int currentInventory = int.tryParse(controller.text) ?? 0;
    int newInventory = currentInventory + change;
    controller.text = newInventory.toString();
  }

  Future<void> _submitInventoryChange(BuildContext context, int id, String itemType, int original, int newInventory) async {
    // TODO: Implement the API call to update the inventory
    // Example:
    Map<String, dynamic> params = {
      'iventory_num': newInventory
    };
    var response = await NetworkUtil.getInstance().put('inventory/${item.id}',params: params);

    // Check response and show success or error message
    if (response?.data['status'] == 200) {
    // 显示SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('库存修改成功！')));

    // 重新获取并刷新库存列表
    } else {
      const snackBar = SnackBar(
        content: Text('库存修改失败!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);    }
  }

}
