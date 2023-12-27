import 'package:flutter/material.dart';
import 'package:untitled/model/workshop.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/vo/workshop_status_vo.dart';

class ProducingStatusBoard extends StatefulWidget {
  const ProducingStatusBoard({super.key});

  @override
  State<ProducingStatusBoard> createState() => _ProducingStatusBoardState();
}

class _ProducingStatusBoardState extends State<ProducingStatusBoard> {
  late int currentWorkshopId = 1;
  List<Workshop> workshops = [];
  List<WorkshopStatusVO> workshopStatus = [];

  init() async {
    // 获取所有的车间
    await getWorkshops();
    // 获取车间下的设备状态
    await getStates(currentWorkshopId);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  getWorkshops() async {
    var result = await NetworkUtil.getInstance()
        .get("workshop/workshops?start=1&limit=10");
    // debugPrint('请求结果：${result?.data}');

    if (result?.data['status'] == 200) {
      List<dynamic> list = result?.data['data']['item'];
      for (int i = 0; i < list.length; i++) {
        workshops.add(Workshop(list[i]['id'], list[i]['workshop_name']));
      }
    }
    currentWorkshopId = workshops[0].id;
  }

  getStates(int workshopId) async {
    workshopStatus = [];
    Map<String, dynamic> params = {};
    params['workshop_id'] = workshopId;
    var result = await NetworkUtil.getInstance()
        .post("screen/productionBoard", params: params);
    // debugPrint('请求结果：${result?.data}');

    if (result?.data['status'] == 200) {
      List<dynamic> list = result?.data['data'];
      for (int i = 0; i < list.length; i++) {
        workshopStatus.add(WorkshopStatusVO.fromJson(list[i]));
      }
    }
    setState(() {});
  }

  Container _buildCard(WorkshopStatusVO workshopStatusVO) => Container(
        alignment: Alignment.center,
        width: 10,
        height: 3000,
        color: Colors.purple[50],
        child: Column(
          children: <Widget>[
            Text(workshopStatusVO.machineName),
            Card(
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  '${workshopStatusVO.percent}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Text('${workshopStatusVO.machineStatus}')
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: DropdownButton(
              value: currentWorkshopId,
              items: workshops
                  .map((item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.workshopName),
                      ))
                  .toList(),
              onChanged: (value) {
                currentWorkshopId = value!;
                getStates(currentWorkshopId);
                setState(() {});
              }),
        ),
        Expanded(
            flex: 6,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 20,
              childAspectRatio: 1 / 1.3,
              children: workshopStatus.map((item) => _buildCard(item)).toList(),
            ))
      ],
    );
  }
}
