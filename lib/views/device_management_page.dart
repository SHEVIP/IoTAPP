import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/components/work/device_card.dart';
import 'package:untitled/model/device.dart';
import 'package:untitled/model/exception.dart';
import 'package:untitled/utils/network_util.dart';
import 'package:untitled/utils/prefs_util.dart';
class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({super.key});

  @override
  State<DeviceManagementPage> createState() => _DeviceManagementPageState();
}
class _DeviceManagementPageState extends State<DeviceManagementPage> {
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
        List<dynamic> items = result.data['data']['new_machines'];
        items.addAll(result.data['data']['third_party_machines']);
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
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       toolbarHeight: 0,
//     ),
//     body: _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: _devices.length, // 使用_devices列表的长度作为列表项计数
//             itemBuilder: (context, index) {
//               // 获取对应索引的设备
//               final device = _devices[index];
//               final exceptionName = DeviceException.findNameById(device.machine_status_id);
//               return DeviceCard(
//                 deviceName: device.name, // 使用设备的名称
//                 deviceId: device.id,
//                 deviceStatus_name: exceptionName,
//                 onTap: () => reportException(context, device), // 传入设备名称到异常上报函数
//               );
//             },
//           ),
//   );
// }

  Color getStatusColor(String status) {
    switch (status) {
      case 'READY':
        return Colors.green;
      case 'NOT-READY':
        return Colors.red;
      case 'EMG':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 每行展示三个设备
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 2.5, // 控制卡片宽高比
          ),
          itemCount: _devices.length,
          itemBuilder: (context, index) {
            final device = _devices[index];
            final exceptionName =
            DeviceException.findNameById(device.machine_status_id);
            final statusColor = getStatusColor(exceptionName);

            return GestureDetector(
              onTap: () => reportException(context, device),
              child: Card(
                color: statusColor.withOpacity(0.2), // 根据状态设置颜色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: statusColor, width: 1.5),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        device.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exceptionName,
                        style: TextStyle(
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void reportException(BuildContext context, Device device) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                      return ElevatedButton(
                        onPressed: () async {
                          await reportDeviceException(device, exception.id);
                          Navigator.pop(context);
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

