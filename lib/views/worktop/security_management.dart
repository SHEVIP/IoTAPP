import 'package:flutter/material.dart';

import '../../model/workshop.dart';
import '../../utils/network_util.dart';

class SecurityManagementPage extends StatefulWidget {
  const SecurityManagementPage({super.key});

  @override
  State<SecurityManagementPage> createState() => _SecurityManagementPageState();
}

// TODO 把按钮的逻辑抽离出来
class _SecurityManagementPageState extends State<SecurityManagementPage> {
  List<Workshop> workshops = [];
  late int currentWorkshopId = 1;
  late int accidentId;
  final TextEditingController accidentIdController = TextEditingController();
  bool select1 = false;
  bool select2 = false;
  bool select3 = false;
  bool select4 = false;
  bool select5 = false;

  @override
  void initState() {
    super.initState();
    getWorkshops();
  }

  getWorkshops() async {
    var result = await NetworkUtil.getInstance()
        .get("workshop/workshops?start=1&limit=10");

    if (result?.data['status'] == 200) {
      List<dynamic> list = result?.data['data']['item'];
      for (int i = 0; i < list.length; i++) {
        workshops.add(Workshop(list[i]['id'], list[i]['workshop_name']));
      }
    }
    currentWorkshopId = workshops[0].id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "安全事故上报",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: '选择车间',
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 0.0, horizontal: 10.0), // 减小垂直填充
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            value: currentWorkshopId,
            items: workshops.map((item) {
              return DropdownMenuItem(
                value: item.id,
                child: Text(item.workshopName),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  currentWorkshopId = newValue;
                });
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Container(alignment:Alignment.centerLeft,child: Text("选择事故:"),),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 5,
            children: [
              select1
                  ? MaterialButton(
                      onPressed: () {},
                      child: Text("机械伤害"),
                      color: Colors.green,
                      textColor: Colors.white,
                      splashColor: Colors.black,
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        side: const BorderSide(color: Colors.green),
                      ),
                onPressed: () {
                  select1 = true;
                  select2 = false;
                  select3 = false;
                  select4 = false;
                  select5 = false;
                  setState(() {});
                },
                      child: const Text(
                        "机械伤害",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
              select2
                  ? MaterialButton(
                      onPressed: () {},
                      child: Text("跌倒和绊倒事故"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      splashColor: Colors.black,
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        side: const BorderSide(color: Colors.blue),
                      ),
                onPressed: () {
                  select2 = true;
                  select1 = false;
                  select3 = false;
                  select4 = false;
                  select5 = false;
                  setState(() {});
                },
                      child: const Text(
                        "跌倒和绊倒事故",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
              select3
                  ? MaterialButton(
                      onPressed: () {},
                      child: Text("化学品泄露"),
                      color: Colors.purple,
                      textColor: Colors.white,
                      splashColor: Colors.black,
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        side: const BorderSide(color: Colors.purple),
                      ),
                onPressed: () {
                  select3 = true;
                  select1 = false;
                  select2 = false;
                  select4 = false;
                  select5 = false;
                  setState(() {});
                },
                      child: const Text(
                        "化学品泄露",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
              select4
                  ? MaterialButton(
                      onPressed: () {},
                      child: Text("人为错误"),
                      color: Colors.orange,
                      textColor: Colors.white,
                      splashColor: Colors.black,
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        side: const BorderSide(color: Colors.orange),
                      ),
                onPressed: () {
                  select4 = true;
                  select1 = false;
                  select2 = false;
                  select3 = false;
                  select5 = false;
                  setState(() {});
                },
                      child: const Text(
                        "人为错误",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
              select5
                  ? MaterialButton(
                      onPressed: () {},
                      child: Text("火灾和爆炸"),
                      color: Colors.red,
                      textColor: Colors.white,
                      splashColor: Colors.black,
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        side: const BorderSide(color: Colors.pink),
                      ),
                      onPressed: () {
                        select5 = true;
                        select1 = false;
                        select2 = false;
                        select3 = false;
                        select4 = false;
                        setState(() {});
                      },
                      child: const Text(
                        "火灾和爆炸",
                        style: TextStyle(color: Colors.pink),
                      ),
                    )
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(20),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: () {},
              child: const Text(
                "提交",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }
}
