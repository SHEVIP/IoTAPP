import 'package:flutter/material.dart';
import 'package:untitled/enums/machine_status.dart';
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
  late int currentProcedureId = 1;
  List<Workshop> workshops = [];
  List<WorkshopStatusVO> workshopStatus = [];
  List<WorkshopStatusVO> procedureStatus = [];
  Map<num, String> procedures = {};

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

    if (result?.data['data'] == null) {
      workshopStatus = [];
      procedures = {};
      procedureStatus = [];
      setState(() {});
      return;
    }

    if (result?.data['status'] == 200) {
      List<dynamic> list = result?.data['data'];

      for (int i = 0; i < list.length; i++) {
        workshopStatus.add(WorkshopStatusVO.fromJson(list[i]));
        procedures[list[i]['procrdure_id']] = list[i]['procrdure_name'];
      }
    }
    getProcedureStates(workshopStatus[0].procedureId);
    setState(() {});
  }

  getProcedureStates(int procedureId) {
    procedureStatus = workshopStatus
        .where((element) => element.procedureId == procedureId)
        .toList();
    setState(() {});
  }

  List<DropdownMenuItem> getProcedureItemList() {
    List<DropdownMenuItem> list = [];
    procedures.forEach((id, name) =>
        list.add(DropdownMenuItem(value: id, child: Text('${id}_$name'))));
    return list;
  }

  Color getContainerColor(int machineStatus) {
    const colors = [
      Colors.white,
      Colors.green,
      Colors.amber,
      Colors.grey,
       Colors.red,
       Colors.red,
       Colors.red,
       Colors.red,
       Colors.red,
       Colors.red,
       Colors.red,

    ];
    return colors[machineStatus];
  }

  Container _buildCard(WorkshopStatusVO workshopStatusVO) => Container(
        alignment: Alignment.center,
        width: 10,
        height: 3000,
        color: Colors.black12,
        child: Column(
          children: <Widget>[
            Text(workshopStatusVO.machineName),
            Card(
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                color: getContainerColor(workshopStatusVO.machineStatus),
                child: Text(
                  '${(workshopStatusVO.percent * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Text(MachineStatusType.getTypeFormIndex(
                    workshopStatusVO.machineStatus)
                .name)
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('选择车间：'),
            DropdownButton(
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
                }),
            const Text('选择产线：'),
            DropdownButton(
                value: currentProcedureId,
                items: getProcedureItemList(),
                onChanged: (value) {
                  currentProcedureId = value!;
                  getProcedureStates(currentProcedureId);
                }),
          ],
        ),
        Expanded(
            flex: 6,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 20,
              childAspectRatio: 1 / 1.3,
              children:
                  procedureStatus.map((item) => _buildCard(item)).toList(),
            ))
      ],
    );
  }
}
