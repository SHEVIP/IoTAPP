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
  Set<int> procedures = {};

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
        procedures.add(list[i]['task_id']);
      }
    }
    getProcedureStates(workshopStatus[0].taskId);
    setState(() {});
  }

  getProcedureStates(int procedureId) {
    procedureStatus = workshopStatus
        .where((element) => element.taskId == procedureId)
        .toList();
    setState(() {});
  }

  List<DropdownMenuItem<int>> getProcedureItemList() {
    List<DropdownMenuItem<int>> list = [];
    for (var id in procedures) {
      list.add(DropdownMenuItem<int>(value: id, child: Text('产线$id')));
    }
    return list;
  }
String _formatDateString(String dateString) {
  // 从字符串末尾移除 ' +0000 UTC'
  String isoDateStr = dateString.replaceAll(' +0000 UTC', '');
  // 日期和时间之间加入'T'
  isoDateStr = isoDateStr.replaceAll(' ', 'T');
  // 添加'Z'表示UTC时间
  isoDateStr += 'Z';
  return isoDateStr;
}

String _getDuration(String endTime) {
  String formattedEndTime = _formatDateString(endTime);
  DateTime end = DateTime.parse(formattedEndTime);
  Duration duration = DateTime.now().toUtc().difference(end);
  int totalMinutes = duration.inMinutes;
  int hours = totalMinutes ~/ 60; // 使用地板除法来获取完整小时数
  int minutes = totalMinutes % 60; // 获取剩余分钟数
  return '${hours}小时${minutes}分钟';
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
  margin: const EdgeInsets.all(8.0), // 添加边距
  alignment: Alignment.center,
  decoration: BoxDecoration(
    color: Colors.black12,
    borderRadius: BorderRadius.circular(8.0), // 圆角
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 6,
        offset: Offset(0, 3), // 阴影位置
      ),
    ],
  ),
  child: SingleChildScrollView( // 避免溢出
    child: ConstrainedBox( // 限制最小高度
      constraints: BoxConstraints(
        minHeight: 140.0, // 最小高度，可以根据需要调整
      ),
      child: IntrinsicHeight( // 调整高度以适应内容
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 居中内容
          children: <Widget>[
            Text(workshopStatusVO.machineName),
            SizedBox(height: 4.0), // 添加一些间距
            Card(
              elevation: 2.0, // 卡片阴影
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // 卡片圆角
              ),
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: getContainerColor(workshopStatusVO.machineStatus),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '${(workshopStatusVO.percent * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(MachineStatusType.getTypeFormIndex(workshopStatusVO.machineStatus).name)
          ],
        ),
      ),
    ),
  ),
);
  
  
  
// 根据状态码获取对应的颜色
Color _getStatusColor(int status) {
  switch (status) {
    case 1:
      return Colors.green;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.grey;
    case 4:
      return Colors.amber;
    // ... 根据实际的状态添加更多的case...
    default:
      return Colors.red;
  }
} 
  // 构建每个设备的卡片
// Widget _buildMachineCard(WorkshopStatusVO statusVO) {
//   return Container(
//     margin: const EdgeInsets.all(8),
//     padding: const EdgeInsets.all(10),
//     decoration: BoxDecoration(
//       color: _getStatusColor(statusVO.machineStatus),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(statusVO.machineName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         SizedBox(height: 4),
//         Text('负责人: ${statusVO.workerName}'),
//         SizedBox(height: 4),
//         Text('工序: ${statusVO.procedureName}'),
//         SizedBox(height: 4),
//         Text('状态时长: ${_getDuration(statusVO.time)}'),
//         SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: statusVO.percent.toDouble(),
//           backgroundColor: Colors.white,
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
//         ),
//         Text('${(statusVO.percent * 100).toStringAsFixed(2)}%'),
//       ],
//     ),
//   );
// }
   // 构建设备卡片
 Widget _buildMachineCard(WorkshopStatusVO statusVO) {
  MachineStatus status = MachineStatusType.getTypeFormIndex(statusVO.machineStatus);

  return Card(
    color: _getStatusColor(statusVO.machineStatus),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 修改为spaceBetween
        children: <Widget>[
          _buildCardRow(Icons.precision_manufacturing, statusVO.machineName, bold: true),
          _buildCardRow(Icons.person, statusVO.workerName),
          _buildCardRow(Icons.build_circle, 'Task${statusVO.taskId}'),
          _buildCardRow(Icons.list, statusVO.procedureName),
          _buildCardRow(Icons.info_outline, status.name),
          _buildCardRow(Icons.timer, _getDuration(statusVO.time)),
          Flexible( // 包裹在Flexible中，防止溢出
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 30, // 可能需要调整高度
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withAlpha(240)),
                      value: statusVO.percent.toDouble(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${(statusVO.percent * 100).toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildCardRow(IconData icon, String text, {bool bold = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Icon(icon, color: Colors.white),
      SizedBox(width: 5), // Add some space between the icon and the text
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10), // 在Row前面添加空白，20可以根据你的需要调整
        Row(
          children: [
            Flexible(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: '选择车间',
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0), // 减小垂直填充
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
                      getStates(currentWorkshopId);
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: '选择产线',
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                value: currentProcedureId,
                items: getProcedureItemList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      currentProcedureId = newValue;
                      getProcedureStates(currentProcedureId);
                    });
                  }
                },
              ),
            ),
          ],
        ),
        Expanded(
          flex: 5,
          child: GridView.builder(
            itemCount: procedureStatus.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.5,
            ),
            itemBuilder: (context, index) {
              return _buildMachineCard(procedureStatus[index]);
            },
          ),
        ),
      ],
    );
  }
}