import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/components/work/device_card.dart';
import 'package:untitled/model/device.dart';
import 'package:untitled/model/exception.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/utils/prefs_util.dart';
class DeviceManagertPage extends StatefulWidget {
  const DeviceManagertPage({super.key});

  @override
  State<DeviceManagertPage> createState() => _DeviceManagertPageState();
}
class _DeviceManagertPageState extends State<DeviceManagertPage> {
  List<Device> _devices = [];
  List<DeviceException> _deviceExceptions = [];
  List<Device> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _devices.clear();
      _deviceExceptions.clear();
      _isLoading = true;
    });
    Map<String, dynamic> params = {
      "user_id": CommonPreferences.userid.value.toString(),
      "start": 1,
      "limit": 10,
    };

    Map<String, dynamic> params_workshop = {
      "workshop_id": 1,
      "procedure_line_id": 0
    };

    try {
      var exceptionResult = await NetworkUtil.getInstance().get("machineStatus/machineStatuss?start=1&limit=999");
      if (exceptionResult != null && exceptionResult.data['status'] == 200 && exceptionResult.data['data']['item'] != null) {
        List<dynamic> items = exceptionResult.data['data']['item'];
        for (var item in items) {
          int deviceExceptionId = item['id'];
          String deviceExceptionName = item['status_name'];
          DeviceException deviceException = DeviceException(id: deviceExceptionId,name: deviceExceptionName,);
          _deviceExceptions.add(deviceException);
        }
        DeviceException.initializeMap(_deviceExceptions);
      } else {
        debugPrint("ExceptionResult data is null or status is not 200");
      }

      var result = await NetworkUtil.getInstance().post("screen/combinedBoard", params: params_workshop);
      if (result != null && result.data['status'] == 200 && result.data['data'] != null) {
        debugPrint(result.data.toString());
        List<dynamic> newMachines = result.data['data']['new_machines'];
        List<dynamic> thirdPartyMachines = result.data['data']['third_party_machines'];

        // List<dynamic> items = result.data['data']['new_machines'];
        // items.addAll(result.data['data']['third_party_machines']);
        // for (var item in items) {
        //   if(item['machine_id'] != null) {
        //     int machineId = item['machine_id'];
        //     String machinename = item['machine_name'];
        //     // debugPrint(machinename);
        //     int workshopId = item['workshop_id'];
        //     int machine_status_id = item['machine_status'] is Null ? item['machine_status_id'] : item['machine_status'];
        //     Device device = Device(id: machineId,name: machinename, workshopId: workshopId, machine_status_id: machine_status_id);
        //     _devices.add(device);
        //     // await _fetchDeviceName(device);
        //
        //   } else {
        //     debugPrint("Machine data is null");
        //   }
        // }

        _devices = [
          ...newMachines.map((item) => Device.fromJson(item, true)),
          ...thirdPartyMachines.map((item) => Device.fromJson(item, false)),
        ];
      } else {
        debugPrint("Result data is null or status is not 200");
      }
    } on TypeError catch (e) {
      debugPrint("Type error: $e");
    } catch (e) {
      debugPrint("Network request error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _fetchDeviceName(Device device) async {
    try {
      var response = await NetworkUtil.getInstance().get('machine/${device.id}');
      if (response != null && response.data['status'] == 200) {
        String deviceName = response.data['data']['machine_name']; // 根据实际返回的数据结构进行调整
        int workshopId = response.data['data']['workshop_id']; // 根据实际返回的数据结构进行调整
        device.updateName(deviceName);
        device.updateworkshopId(workshopId);
      }
    } catch (e) {
      debugPrint("获取设备名称出错: $e");
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 1: // 三菱 1 EMG
      case 5: // 发那科 0 NOT READY
      case 9: // 发那科 4 B-STOP
      case 10: // 第三方-红
        return Colors.red;
      case 2: // 三菱 2 RDY
      case 4: // 三菱 7 HLD
      case 6: // 发那科 1 M-READY
      case 8: // 发那科 3 F-HOLD
      case 11: // 第三方-黄
        return Colors.yellow;
      case 3: // 三菱 3 AUT
      case 7: // 发那科 2 C-START
      case 12: // 第三方-绿
        return Colors.green;
      default:
        return Colors.grey; // 默认颜色
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // 设置 AppBar 高度
        child: AppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30), // 设置圆角以模拟灵动岛效果
            ),
            alignment: Alignment.center,
            child: Text(
              "经理页面",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.transparent, // 使 AppBar 背景透明，仅显示蓝色的标题部分
          elevation: 0,
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 上半部分：设备状态展示
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '设备状态',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 使用 GridView.builder 来展示设备状态
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      final exceptionName = DeviceException.findNameById(device.machine_status_id);
                      final statusColor = getStatusColor(device.machine_status_id);

                      return GestureDetector(
                        onTap: () => reportException(context, device),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: statusColor.withOpacity(0.5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: statusColor.withOpacity(0.8),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  device.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  exceptionName.isNotEmpty ? exceptionName : '正常',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 分隔线
            Divider(),

            // 下半部分：异常信息展示
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '异常信息',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      final exceptionName = DeviceException.findNameById(device.machine_status_id);

                      return exceptionName.isNotEmpty
                          ? Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        color: Colors.red[100],
                        child: ListTile(
                          leading: Icon(Icons.warning, color: Colors.red[400]),
                          title: Text(
                            device.name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            exceptionName,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      )
                          : SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// // 构建 NewMachine 卡片内容
//   Widget _buildNewMachineCard(NewMachine device) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           device.name,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text('状态: ${device.machine_status_name}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('运行时间: ${device.run_time} 分钟', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('加工时间: ${device.cut_time} 分钟', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('循环时间: ${device.cycle_time} 分钟', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('上电时间: ${device.power_on_time} 分钟', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('告警个数: ${device.alm_count}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('车间号: ${device.workshopId}', style: TextStyle(color: Colors.black, fontSize: 14)),
//       ],
//     );
//   }
//
// // 构建 ThirdPartyMachine 卡片内容
//   Widget _buildThirdPartyMachineCard(ThirdPartyMachine device) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           device.name,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text('状态: ${device.machine_status_name}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('完成托盘计数: ${device.cur1}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('坏料完成计数: ${device.cur2}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('GT2检测高度: ${device.gt2_h_value}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('上料电缸位置: ${device.pos1}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('下料电缸位置: ${device.pos2}', style: TextStyle(color: Colors.black, fontSize: 14)),
//         Text('车间号: ${device.workshopId}', style: TextStyle(color: Colors.black, fontSize: 14)),
//       ],
//     );
//   }


  void reportException(BuildContext context, Device device) {
    int? selectedExceptionId; // 用于保存选中的异常ID
    String? selectedExceptionName; // 用于保存选中的异常名称

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '设备状态上报 - ${device.name}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('选择上报内容：'),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 两列
                          crossAxisSpacing: 10, // 水平间距
                          mainAxisSpacing: 10, // 垂直间距
                          childAspectRatio: 3, // 宽高比为3
                        ),
                        itemCount: _deviceExceptions.length,
                        itemBuilder: (context, index) {
                          final exception = _deviceExceptions[index];
                          final isSelected = selectedExceptionId == exception.id;

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: isSelected ? Colors.blue : Colors.white, // 选中时蓝色，未选中时白底
                              onPrimary: isSelected ? Colors.white : Colors.black, // 选中时白字，未选中时黑字
                              side: BorderSide(color: Colors.grey, width: 0.2), // 添加边框
                            ),
                            onPressed: () {
                              setModalState(() {
                                selectedExceptionId = exception.id; // 更新选中的异常ID
                                selectedExceptionName = exception.name; // 更新选中的异常名称
                              });

                              // 弹出确认上报弹窗
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('确认上报'),
                                    content: Text('设备名称：${device.name}\n\n异常内容：$selectedExceptionName'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // 关闭确认弹窗
                                        },
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop(); // 关闭确认弹窗
                                          Navigator.of(context).pop(); // 关闭底部弹窗
                                          await reportDeviceException(device, selectedExceptionId!);
                                        },
                                        child: const Text('确认'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(exception.name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String formatTimestamp(DateTime dateTime) {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    return formatter.format(dateTime);
  }

  Future<void> reportDeviceException(Device device, int exceptionId) async {
    String timestamp = formatTimestamp(DateTime.now());
    int deviceId = device.id;
    int workshopId = device.workshopId;
    Map<String, dynamic> params = {
      "machine_id": deviceId,
      "machine_status_id": exceptionId,
      "time": timestamp, // ISO 8601 格式的时间戳
    };
    Map<String, dynamic> deviceParams = {
      "workshop_id": workshopId,
      "machine_status_id": exceptionId,
    };

    try {
      var deviceResult = await NetworkUtil.getInstance().put("newMachine/$deviceId", params: deviceParams);
      // 刷新页面
      _loadData();

      var result = await NetworkUtil.getInstance().post("machineLog", params: params);
      params.remove("time");
      var response = await NetworkUtil.getInstance().post('machineAnomaly',params: params);

      // 根据 response 处理结果
      if (response?.data['status'] == 200 && result?.data['status']==200  && deviceResult?.data['status']==200) {
        // 弹出提醒
        const snackBar = SnackBar(
          content: Text('异常上报成功!'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        debugPrint('异常上报成功');

        // 刷新页面
        _loadData();
      } else {
        debugPrint('异常上报失败：${response?.data['status']}');
      }
    } catch (e) {
      debugPrint('发送异常上报请求错误：$e');
    }
  }

}

